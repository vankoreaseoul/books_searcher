//
//  SearchTableViewCell.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var viewModel: SearchTableCellViewModel?
    
    static let identifier = "SearchTableViewCell"
    
    private var thumbnailImageView: BookImageView!
    
    private var titleLbl: UILabel!
    private var subtitleLbl: UILabel!
    private var isbn13Lbl: UILabel!
    private var priceLbl: UILabel!
    private var urlLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        print("SearchTableViewCell init..")
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        print("SearchTableViewCell deinit..")
    }
    
    private func setupUI() {
        thumbnailImageView = BookImageView(frame: .zero)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    
        let verticalStack = setupTextVerticalStackView()
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TABLE_CELL_PADDING),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TABLE_CELL_PADDING),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TABLE_CELL_PADDING),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: THUMBNAIL_WIDTH),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: TABLE_CELL_HEIGHT - 2*TABLE_CELL_PADDING),
            
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TABLE_CELL_PADDING),
            verticalStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: TABLE_CELL_PADDING),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TABLE_CELL_PADDING),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TABLE_CELL_PADDING)
        ])
    }
    
    private func setupTextVerticalStackView() -> UIStackView {
        let titleHorizontalStack = setupTextHorizontalStackView(type: .TITLE)
        let subtitleHorizontalStack = setupTextHorizontalStackView(type: .SUBTITLE)
        let isbnHorizontalStack = setupTextHorizontalStackView(type: .ISBN13)
        let priceHorizontalStack = setupTextHorizontalStackView(type: .PRICE)
        let urlHorizontalStack = setupTextHorizontalStackView(type: .URL)
        
        let verticalStack = UIStackView(arrangedSubviews: [titleHorizontalStack, subtitleHorizontalStack, isbnHorizontalStack, priceHorizontalStack, urlHorizontalStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        verticalStack.distribution = .equalSpacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }
    
    private func setupTextHorizontalStackView(type: SearchResultTextType) -> UIStackView {
        let label = UILabel()
        label.font = .systemFont(ofSize: TABLE_CELL_FONT_SIZE, weight: .bold)
        label.textColor = .black
        label.text = type.rawValue
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let text = UILabel()
        text.font = .systemFont(ofSize: TABLE_CELL_FONT_SIZE)
        text.textColor = .darkGray
        text.setContentHuggingPriority(.defaultLow, for: .horizontal)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let horizontalStack = UIStackView(arrangedSubviews: [label, text])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 4
        horizontalStack.alignment = .firstBaseline
        horizontalStack.distribution = .fill
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .TITLE:
            titleLbl = text
        case .SUBTITLE:
            subtitleLbl = text
        case .ISBN13:
            isbn13Lbl = text
        case .PRICE:
            priceLbl = text
        case .URL:
            urlLbl = text
        }
        
        return horizontalStack
    }
    
    func bindViewModel(viewModel: SearchTableCellViewModel) {
        self.viewModel = viewModel
        
        titleLbl.text = self.viewModel?.title
        subtitleLbl.text = self.viewModel?.subtitle
        isbn13Lbl.text = self.viewModel?.isbn13
        priceLbl.text = self.viewModel?.price
        urlLbl.text = self.viewModel?.url
        
        self.viewModel?.successLoadImage = { [weak self] image in
            self?.thumbnailImageView.successLoadImage(image: image)
        }
        
        self.viewModel?.failLoadImage = { [weak self] in
            self?.thumbnailImageView.failLoadImage()
        }
        
        self.viewModel?.configureImage()
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        thumbnailImageView.loadingImage()
        titleLbl.text = nil
        subtitleLbl.text = nil
        isbn13Lbl.text = nil
        priceLbl.text = nil
        urlLbl.text = nil
    }
}

private enum SearchResultTextType: String {
    case TITLE = "Title:"
    case SUBTITLE = "Subtitle:"
    case ISBN13 = "Isbn13:"
    case PRICE = "Price:"
    case URL = "Url:"
}
