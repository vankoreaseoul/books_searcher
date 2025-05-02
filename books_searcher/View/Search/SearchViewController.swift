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
    
    private let paginationView = PaginationView()
    
    private var spinnerView: SpinnerView!
    
    
    private var keyboardHeight: CGFloat = .zero
    private var tapGesture: UITapGestureRecognizer?
    
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
        
        let searchViewContainer = configureSearchBarView()
        let tableViewContainer = configureTableView()
        let pageViewContainer = configurePageView()
        
        let verticalStack = UIStackView(arrangedSubviews: [searchViewContainer, tableViewContainer, pageViewContainer])
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        configureSpinnerView()
    }
    
    private func configureSpinnerView() {
        spinnerView = SpinnerView(frame: .zero)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configurePageView() -> UIView {
        let container = UIView()
        paginationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(paginationView)
        
        NSLayoutConstraint.activate([
            paginationView.topAnchor.constraint(equalTo: container.topAnchor),
            paginationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            paginationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            paginationView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            paginationView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return container
    }
    
    private func configureTableView() -> UIView {
        let container = UIView()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        searchTableView = UITableView(frame: .zero, style: .plain)
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.rowHeight = TABLE_CELL_HEIGHT
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(searchTableView)
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: container.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func configureSearchBarView() -> UIView {
        let container = UIView()
        
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
        
        container.addSubview(searchTextField)
        container.addSubview(searchBtn)
        
        NSLayoutConstraint.activate([
            searchBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            searchBtn.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -HORIZONTAL_PADDING),
            searchBtn.widthAnchor.constraint(equalToConstant: SEARCH_BTN_WIDTH),
            
            searchTextField.topAnchor.constraint(equalTo: container.topAnchor, constant: HORIZONTAL_PADDING),
            searchTextField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: HORIZONTAL_PADDING),
            searchTextField.rightAnchor.constraint(equalTo: searchBtn.leftAnchor, constant: -HORIZONTAL_PADDING),
            searchTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -HORIZONTAL_PADDING),
            searchTextField.heightAnchor.constraint(equalToConstant: SEARCH_TF_HEIGHT)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        container.addGestureRecognizer(tapGesture)
        
        return container
    }
    
    private func bindViewModel() {
        viewModel.presentSpinner = { [weak self] in
            self?.spinnerView.loading(indicatorStyle: .large)
        }
        
        viewModel.onUpdate = { [weak self] resultType in
            self?.setUpPaginationView()
            self?.searchTableView.reloadData()
            self?.spinnerView.successLoading()
            
            guard resultType != .SUCCESS else { return }
            
            var msg: String = ""
            
            switch resultType {
            case .HAS_SPACE:
                msg = "Spaces are not allowed.\nPlease re-enter without spaces."
                break
            case .FAIL:
                msg = "Can't load data.."
                break
            case .NO_DATA:
                msg = "No data."
                break
            default:
                break
            }
            
            let alert = UIAlertController(title: "Notice", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: false)
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
        if viewModel.books.isEmpty {
            if let hasTapGestureRecognizer = tapGesture { tableView.addGestureRecognizer(hasTapGestureRecognizer) }
        } else {
            if let hasTapGestureRecognizer = tapGesture { tableView.removeGestureRecognizer(hasTapGestureRecognizer) }
        }
        
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let selectedBook = viewModel.books[indexPath.row]
        cell.bindViewModel(viewModel: DIContainer.shared.makeSearchTableCellViewModel(book: selectedBook))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        searchTableView.deselectRow(at: indexPath, animated: true)
        
        let selectedBook = viewModel.books[indexPath.row]
        let detailVC = DetailViewController(viewModel: DIContainer.shared.makeDetailViewModel(book: selectedBook))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
