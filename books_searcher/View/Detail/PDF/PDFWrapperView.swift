//
//  PDFWrapperView.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/2/25.
//

import Foundation
import UIKit
import PDFKit

class PDFWrapperView: UIStackView {
    
    private var titleLbl: UILabel!
    
    private var pdfView: PDFView!
    private var spinnerView: SpinnerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        self.axis = .vertical
        self.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABEL_TEXT
        self.distribution = .equalSpacing
        
        titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE)
        titleLbl.textColor = TEXT_COLOR
        
        pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        spinnerView = SpinnerView(frame: .zero)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        pdfView.addSubview(spinnerView)
        
        self.addArrangedSubview(titleLbl)
        self.addArrangedSubview(pdfView)
        
        NSLayoutConstraint.activate([
            spinnerView.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: pdfView.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: pdfView.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: pdfView.bottomAnchor),
            
            pdfView.heightAnchor.constraint(equalToConstant: PDF_VIEW_HEIGHT)
        ])
    }
    
    func configureTitle(key: String) {
        titleLbl.text = key
        spinnerView.loading()
        pdfView.document = nil
    }
    
    func configurePDF(document: PDFDocument) {
        spinnerView.successLoading()
        pdfView.document = document
    }
}
