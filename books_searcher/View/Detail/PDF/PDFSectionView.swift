//
//  PDFSectionView.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/2/25.
//

import Foundation
import UIKit
import PDFKit

class PDFSectionView: UIStackView {
    
    private var contentView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABEL_TEXT
        self.distribution = .equalSpacing
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setup(_ keys: [String]) {
        let titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE, weight: .bold)
        titleLbl.textColor = LABEL_COLOR
        titleLbl.text = "Pdf"
        
        let container = UIView()
        
        let pdfWrapperViews =  keys.map {
            let wrapperView = PDFWrapperView(frame: .zero)
            wrapperView.configureTitle(key: $0)
            wrapperView.accessibilityIdentifier = $0
            return wrapperView
        }
        
        contentView = UIStackView(arrangedSubviews: pdfWrapperViews)
        contentView.axis = .vertical
        contentView.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABELS
        contentView.distribution = .equalSpacing
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: container.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: HORIZONTAL_PADDING*2),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -HORIZONTAL_PADDING*2)
            ])
        
        self.addArrangedSubview(titleLbl)
        self.addArrangedSubview(container)
    }
    
    func configurePDF(key: String, pdfDocument: PDFDocument) {
        if let pdfWrapperView = contentView.subviews.first(where: { $0.accessibilityIdentifier == key }) as? PDFWrapperView {
            pdfWrapperView.configurePDF(document: pdfDocument)
        } else {
            failLoadingPDF(key)
        }
    }
    
    func failLoadingPDF(_ key: String) {
        contentView.removeFromSuperview()
        
        let pdfNameLbl = UILabel()
        pdfNameLbl.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE)
        pdfNameLbl.textColor = TEXT_COLOR
        pdfNameLbl.text = key
        
        let errorLbl = UILabel()
        errorLbl.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE)
        errorLbl.textColor = .systemRed
        errorLbl.text = "Can't upload PDF File..."
        
        self.addArrangedSubview(pdfNameLbl)
        self.addArrangedSubview(errorLbl)
    }
    
}
