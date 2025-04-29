//
//  SearchViewController.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private var searchTextField: UITextField!
    private var searchBtn: UIButton!
    private var searchTableView: UITableView!
    private var keyboardHeight: CGFloat = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        subscribeKeyboardPresence()
    }
    
    deinit {
        unsubscribeKeyboardPresence()
    }

    private func configureUI() {
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
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // ?????
        searchTableView.rowHeight = 100
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchTextField)
        view.addSubview(searchBtn)
        view.addSubview(searchTableView)
        
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
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func searchBtnTapped() {
        dismissKeyboard()
        
        guard let query = searchTextField.text, !query.isEmpty else { return }
        viewModel.searchBooks(query: query)
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
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
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
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}

