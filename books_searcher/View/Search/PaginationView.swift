//
//  PaginationView.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import UIKit

class PaginationView: UIView {
    
    private let stackView = UIStackView()
    var didTapPageBtn: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.isHidden = true
    }
    
    func configureUI(current: Int, total: Int) {
        print("current = \(current)")
        print("total = \(total)")
        
        guard current != .zero && total != .zero else {
            stackView.isHidden = true
            return
        }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(makeButton(title: "<", page: current - 1, total: total, isEnabled: current > 1))

        if current > 2 {
            stackView.addArrangedSubview(makeButton(title: "1", page: 1, total: total))
            if current > 3 {
                stackView.addArrangedSubview(makeEllipsis())
            }
        }

        let range = max(1, current - 1)...min(total, current + 1)
        for page in range {
            stackView.addArrangedSubview(makeButton(title: "\(page)", page: page, total: total, isCurrent: page == current))
        }

        if current < total - 1 {
            if current < total - 2 {
                stackView.addArrangedSubview(makeEllipsis())
            }
            stackView.addArrangedSubview(makeButton(title: "\(total)", page: total, total: total))
        }

        stackView.addArrangedSubview(makeButton(title: ">", page: current + 1, total: total, isEnabled: current < total))
        
        stackView.isHidden = false
    }

    private func makeButton(title: String, page: Int, total: Int, isCurrent: Bool = false, isEnabled: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = isCurrent ? .systemBlue : .clear
        button.tintColor = isCurrent ? .white : .systemBlue
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderColor = isCurrent ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        button.isEnabled = isEnabled
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.didTapPageBtn?(page)
        }, for: .touchUpInside)
        
        return button
    }

    private func makeEllipsis() -> UILabel {
        let label = UILabel()
        label.text = "..."
        label.textColor = .gray
        label.font = .systemFont(ofSize: TABLE_CELL_FONT_SIZE)
        return label
    }
    
}

