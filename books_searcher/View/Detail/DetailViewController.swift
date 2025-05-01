//
//  DetailViewController.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    
    private var detailImageView: BookImageView!
    
    private var titleLbl: UILabel!
    private var subtitleLbl: UILabel!
    private var authorsLbl: UILabel!
    private var publisherLbl: UILabel!
    private var isbn10Lbl: UILabel!
    private var isbn13Lbl: UILabel!
    private var pagesLbl: UILabel!
    private var yearLbl: UILabel!
    private var ratingLbl: UILabel!
    private var descLbl: UILabel!
    private var priceLbl: UILabel!
    private var urlLbl: UILabel!
    
    private var pdfVerticalStackView: UIStackView!
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("DetailViewController init..")
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        print("DetailViewController deinit..")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        detailImageView = BookImageView(frame: .zero)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = setupContentVerticalStackView()
        
        scrollView.addSubview(detailImageView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(pdfVerticalStackView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            detailImageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            detailImageView.widthAnchor.constraint(equalToConstant: DETAIL_VIEW_IMAGE_WIDTH),
            detailImageView.heightAnchor.constraint(equalToConstant: DETAIL_VIEW_IMAGE_HEIGHT),
            
            stackView.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABELS),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: HORIZONTAL_PADDING),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -HORIZONTAL_PADDING),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -HORIZONTAL_PADDING*2)
        ])
    }
    
    private func setupContentVerticalStackView() -> UIStackView {
        let types: [DetailResultTextType] = [.TITLE, .SUBTITLE, .AUTHORS, .PUBLISHER, .ISBN10, .ISBN13, .PAGES, .YEAR, .RATING, .DESC, .PRICE, .URL]
        var labelViews = types.map { setupLabelView(type: $0) }
        pdfVerticalStackView = setupPDFVerticalStackView()
        labelViews.append(pdfVerticalStackView)
        
        let verticalStack = UIStackView(arrangedSubviews: labelViews)
        
        verticalStack.axis = .vertical
        verticalStack.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABELS
        verticalStack.distribution = .equalSpacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }
    
    private func setupLabelView(type: DetailResultTextType) -> UIStackView {
        let label = UILabel()
        label.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE, weight: .bold)
        label.textColor = LABEL_COLOR
        label.text = type.rawValue
        
        let text = UILabel()
        text.font = .systemFont(ofSize: DETAIL_VIEW_FONT_SIZE)
        text.textColor = TEXT_COLOR
        text.numberOfLines = 0
        
        let verticalStack = UIStackView(arrangedSubviews: [label, text])
        verticalStack.axis = .vertical
        verticalStack.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABEL_TEXT
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .TITLE:
            titleLbl = text
        case .SUBTITLE:
            subtitleLbl = text
        case .AUTHORS:
            authorsLbl = text
        case .PUBLISHER:
            publisherLbl = text
        case .ISBN10:
            isbn10Lbl = text
        case .ISBN13:
            isbn13Lbl = text
        case .PAGES:
            pagesLbl = text
        case .YEAR:
            yearLbl = text
        case .RATING:
            ratingLbl = text
        case .DESC:
            descLbl = text
        case .PRICE:
            priceLbl = text
        case .URL:
            urlLbl = text
        }
        
        return verticalStack
    }
    
    private func setupPDFVerticalStackView() -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = DETAIL_VIEW_VERTICAL_PADDING_BETWEEN_LABELS
        verticalStack.distribution = .equalSpacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }
    
    private func bindViewModel() {
        viewModel.successGetBookDetail = { [weak self] detail in
            self?.updateLabelTexts(detail: detail)
        }
        
        viewModel.failGetBookDetail = { [weak self] msg in
            let alert = UIAlertController(title: "Notice", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: false)
        }
        
        viewModel.successGetBookImage = { [weak self] image in
            self?.detailImageView.successLoadImage(image: image)
        }
        
        viewModel.failGetBookImage = { [weak self] in
            self?.detailImageView.failLoadImage()
        }
        
        viewModel.getBookDetail()
    }
    
    
    private func updateLabelTexts(detail: BookDetail) {
        titleLbl.text = detail.title
        subtitleLbl.text = detail.subtitle
        authorsLbl.text = detail.authors
        publisherLbl.text = detail.publisher
        isbn10Lbl.text = detail.isbn10
        isbn13Lbl.text = detail.isbn13
        pagesLbl.text = detail.pages
        yearLbl.text = detail.year
        ratingLbl.text = detail.rating
        descLbl.text = detail.desc
        priceLbl.text = detail.price
        urlLbl.text = detail.url
    }
    
}

private enum DetailResultTextType: String {
    case TITLE = "Title"
    case SUBTITLE = "Subtitle"
    case AUTHORS = "Authors"
    case PUBLISHER = "Publisher"
    case ISBN10 = "Isbn10"
    case ISBN13 = "Isbn13"
    case PAGES = "Pages"
    case YEAR = "Year"
    case RATING = "Rating"
    case DESC = "desc"
    case PRICE = "Price"
    case URL = "Url"
}
