//
//  BookImageView.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import UIKit

class BookImageView: UIImageView {
    
    private var spinnerView: UIView!
    private var indicator: UIActivityIndicatorView!
    private var errorLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        
        spinnerView = UIView()
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false

        indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        errorLbl = UILabel()
        errorLbl.adjustsFontSizeToFitWidth = true
        errorLbl.textColor = .white
        errorLbl.text = "No Image"
        errorLbl.translatesAutoresizingMaskIntoConstraints = false

        spinnerView.addSubview(errorLbl)
        spinnerView.addSubview(indicator)
        addSubview(spinnerView)
        
        loadingImage()
        
        NSLayoutConstraint.activate([
            spinnerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: self.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            errorLbl.leadingAnchor.constraint(equalTo: spinnerView.leadingAnchor, constant: 4),
            errorLbl.trailingAnchor.constraint(equalTo: spinnerView.trailingAnchor, constant: -4),
            errorLbl.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            errorLbl.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor)
        ])
    }
    
    func loadingImage() {
        spinnerView.isHidden = false
        errorLbl.isHidden = true
        indicator.isHidden = false
        self.image = nil
    }
    
    func failLoadImage() {
        spinnerView.isHidden = false
        errorLbl.isHidden = false
        indicator.isHidden = true
        self.image = nil
    }
    
    func successLoadImage(image: UIImage) {
        spinnerView.isHidden = true
        self.image = image
    }
    
}
