//
//  SpinnerView.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import UIKit

class SpinnerView {
    
    static let shared = SpinnerView()
    private init() {}
    
    private var spinnerContainer: UIView?

    func show(on view: UIView?) {
        guard spinnerContainer == nil, let hasView = view else { return }
        
        let container = UIView(frame: hasView.bounds)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = container.center
        indicator.startAnimating()

        container.addSubview(indicator)
        hasView.addSubview(container)

        spinnerContainer = container
    }

    func hide() {
        spinnerContainer?.removeFromSuperview()
        spinnerContainer = nil
    }
}
