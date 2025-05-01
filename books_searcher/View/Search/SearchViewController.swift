//
//  SearchViewController.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel
    
    private var searchTextField: UITextField!
    private var searchBtn: UIButton!
    private var searchTableView: UITableView!
    private var keyboardHeight: CGFloat = .zero
    
    private let paginationView = PaginationView()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("SearchViewController init..")
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        unsubscribeKeyboardPresence()
        print("SearchViewController deinit..")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        subscribeKeyboardPresence()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Book Search"
        
        searchTextField = UITextField()
        searchTextField.placeholder = "Enter search term"
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchBtn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .blue
        config.title = "Search"
        searchBtn.configuration = config
        searchBtn.layer.cornerRadius = 8
        searchBtn.layer.masksToBounds = true
        searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        
        searchTableView = UITableView(frame: .zero, style: .plain)
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.rowHeight = TABLE_CELL_HEIGHT
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchTextField)
        view.addSubview(searchBtn)
        view.addSubview(searchTableView)
        view.addSubview(paginationView)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            searchBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchBtn.widthAnchor.constraint(equalToConstant: 100),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchTextField.rightAnchor.constraint(equalTo: searchBtn.leftAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            searchTableView.topAnchor.constraint(equalTo: searchBtn.bottomAnchor, constant: 28),
            searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: paginationView.topAnchor, constant: -16),
            
            paginationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            paginationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            paginationView.rightAnchor.constraint(equalTo: view.rightAnchor),
            paginationView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        viewModel.presentAlert = { [weak self] msg in
            let alert = UIAlertController(title: "Notice", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self?.viewModel.resetComponents()
            }))
            self?.present(alert, animated: false)
        }
        
        viewModel.onUpdate = { [weak self] in
            self?.setUpPaginationView()
            self?.searchTableView.reloadData()
        }
    }
    
    private func setUpPaginationView() {
        paginationView.configureUI(current:  viewModel.currentPage, total: viewModel.totalPages)
        paginationView.didTapPageBtn = { [weak self] page in
            self?.viewModel.didTapPageBtn(page: page)
        }
    }
    
    @objc private func searchBtnTapped() {
        dismissKeyboard()
        viewModel.didTapSearchBtn(query: searchTextField.text ?? "", page: 1)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func subscribeKeyboardPresence() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardPresence() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, keyboardHeight == .zero else { return }
        keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.size.height -= self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.size.height += self.keyboardHeight
            self.view.layoutIfNeeded()
            self.keyboardHeight = .zero
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let selectedBook = viewModel.books[indexPath.row]
        cell.bindViewModel(viewModel: DIContainer.shared.makeSearchTableCellViewModel(book: selectedBook))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.books[indexPath.row]
        let detailVC = DetailViewController(viewModel: DIContainer.shared.makeDetailViewModel(book: selectedBook))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
