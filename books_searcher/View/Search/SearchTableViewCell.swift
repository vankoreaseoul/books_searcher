//
//  SearchTableViewCell.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import UIKit
import Combine

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    private var thumbnailImageView: UIImageView!
    
    private var spinnerView: UIView!
    private var indicator: UIActivityIndicatorView!
    private var errorLbl: UILabel!
    
    private var titleLbl: UILabel!
    private var subtitleLbl: UILabel!
    private var isbn13Lbl: UILabel!
    private var priceLbl: UILabel!
    private var urlLbl: UILabel!
    
    private var loadBookImageUsecase: LoadBookImageUsecase?
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        print("SearchTableViewCell deinit..")
    }
    
    private func setupUI() {
        thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 6
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupSpinnerView()
        thumbnailImageView.addSubview(spinnerView)
        loadingImage()
    
        let verticalStack = setupTextVerticalStackView()
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            spinnerView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            
            errorLbl.leadingAnchor.constraint(equalTo: spinnerView.leadingAnchor, constant: 4),
            errorLbl.trailingAnchor.constraint(equalTo: spinnerView.trailingAnchor, constant: -4),
            errorLbl.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            errorLbl.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TABLE_CELL_PADDING),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TABLE_CELL_PADDING),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TABLE_CELL_PADDING),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: THUMBNAIL_WIDTH),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: TABLE_CELL_HEIGHT - 2*TABLE_CELL_PADDING),
            
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TABLE_CELL_PADDING),
            verticalStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: TABLE_CELL_PADDING),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TABLE_CELL_PADDING),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TABLE_CELL_PADDING),
        ])
    }
    
    private func loadingImage() {
        spinnerView.isHidden = false
        errorLbl.isHidden = true
        indicator.isHidden = false
    }
    
    private func failLoadImage() {
        spinnerView.isHidden = false
        errorLbl.isHidden = false
        indicator.isHidden = true
    }
    
    private func successLoadImage() {
        spinnerView.isHidden = true
    }
    
    private func setupSpinnerView() {
        spinnerView = UIView()
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false

        indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        errorLbl = UILabel()
        errorLbl.adjustsFontSizeToFitWidth = true
        errorLbl.textColor = .white
        errorLbl.text = "No Image"
        errorLbl.translatesAutoresizingMaskIntoConstraints = false

        spinnerView.addSubview(errorLbl)
        spinnerView.addSubview(indicator)
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
    
    private func setupTextHorizontalStackView(type: TextType) -> UIStackView {
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
    
    func configure(book: Book, usecase: LoadBookImageUsecase) {
        titleLbl.text = book.title
        subtitleLbl.text = book.subtitle
        isbn13Lbl.text = book.isbn13
        priceLbl.text = book.price
        urlLbl.text = book.url
        
        loadBookImageUsecase = usecase
        putImage(url: book.image)
    }
    
    private func putImage(url: String) {
        loadBookImageUsecase?.execute(url: url)
            .sink { [weak self] completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self?.failLoadImage()
                    print("[Load Image Fail] Error: \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] image in
                self?.successLoadImage()
                self?.thumbnailImageView.image = image
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        loadingImage()
        titleLbl.text = nil
        subtitleLbl.text = nil
        isbn13Lbl.text = nil
        priceLbl.text = nil
        urlLbl.text = nil
    }
}

private enum TextType: String {
    case TITLE = "Title:"
    case SUBTITLE = "Subtitle:"
    case ISBN13 = "Isbn13:"
    case PRICE = "Price:"
    case URL = "Url:"
}
