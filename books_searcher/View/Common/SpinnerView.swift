//
//  SpinnerView.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import UIKit

class SpinnerView: UIView {
    
    private var indicator: UIActivityIndicatorView!
    private var errorLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        errorLbl = UILabel()
        errorLbl.adjustsFontSizeToFitWidth = true
        errorLbl.textAlignment = .center
        errorLbl.textColor = .white
        errorLbl.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(errorLbl)
        self.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            errorLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            errorLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            errorLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.isHidden = true
    }
    
    func loading(indicatorStyle: UIActivityIndicatorView.Style = .medium) {
        self.isHidden = false
        indicator.isHidden = false
        indicator.style = indicatorStyle
        errorLbl.isHidden = true
    }
    
    func failLoading(errorMsg: String) {
        self.isHidden = false
        indicator.isHidden = true
        errorLbl.isHidden = false
        errorLbl.text = errorMsg
    }
    
    func successLoading() {
        self.isHidden = true
    }
    
}
