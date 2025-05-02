//
//  BookImageView.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import UIKit

class BookImageView: UIImageView {
    
    private var spinnerView: SpinnerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        
        spinnerView = SpinnerView(frame: .zero)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: self.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        loadingImage()
    }
    
    func loadingImage() {
        spinnerView.loading()
        self.image = nil
    }
    
    func failLoadImage() {
        spinnerView.failLoading(errorMsg: "No Image")
        self.image = nil
    }
    
    func successLoadImage(image: UIImage) {
        spinnerView.successLoading()
        self.image = image
    }
    
}
