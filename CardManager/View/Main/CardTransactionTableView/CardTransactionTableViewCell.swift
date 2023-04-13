//
//  CardTransactionTableViewCell.swift
//  CardManager
//
//  Created by Apple on 2023/02/19.
//

import UIKit

final class CardTransactionTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private let containerView = UIView()
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let productNameLabel = UILabel()
    private let transactionTypeLabel = UILabel()
    private let dateLabel = UILabel()
    private let costStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let costTitleLabel = UILabel()
    private let costLabel = UILabel()
    
    // MARK: - Constants
    static let identifier = "CardTransactionTableViewCell"
    private let costTitle = "결제금액"
    private let productName = "중규마켓"
    private let costText = { (cost: Int) -> String in
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let costText = numberFormatter.string(from: NSNumber(value: cost)) else {
            return "알 수 없음"
        }
        return costText + "원"
    }
    private let cornerRadius: CGFloat = 10.0
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCell()
        setUpContainerView()
        setUpContainerStackView()
        setUpProductStackView()
        setUpProductNameLabel()
        setUpTransactionTypeLabel()
        setUpDateLabel()
        setUpCostStackView()
        setUpCostTitleLabel()
        setUpCostLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Cell
extension CardTransactionTableViewCell {
    
    private func setUpCell() {
        addSubviews()
        setStyleOfCell()
    }
    
    private func addSubviews() {
        [containerView].forEach { addSubview($0) }
    }
    
    private func setStyleOfCell() {
        backgroundColor = .clear
    }
    
    func setContent(productName: String, date: String, cost: Int, transactionType: String) {
        setContentOfProductNameLabel(to: productName)
        setContentOfDateLabel(to: date)
        setContentOfCostLabel(to: cost)
        setContentOfTransactionTypeLabel(to: transactionType)
    }
    
}

// MARK: - Container View: 전체 컨테이너 뷰
extension CardTransactionTableViewCell {
    
    private func setUpContainerView() {
        addSubviewsOfContainerView()
        setStyleOfContainerView()
        setConstraintsOfContainerView()
    }
    
    private func addSubviewsOfContainerView() {
        [containerStackView].forEach { containerView.addSubview($0) }
    }
    
    private func setStyleOfContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = cornerRadius
    }
    
    private func setConstraintsOfContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
}

// MARK: - Container StackView: 컨테이너 스택 뷰
extension CardTransactionTableViewCell {

    private func setUpContainerStackView() {
        addSubviewsOfContainerStackView()
        setStyleOfContainerStackView()
        setConstraintsOfContainerStackView()
    }
    
    private func addSubviewsOfContainerStackView() {
        [productStackView, dateLabel, costStackView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setStyleOfContainerStackView() {
        containerStackView.backgroundColor = .clear
    }
    
    private func setConstraintsOfContainerStackView() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
        ])
    }
    
}

// MARK: - Product StackView: 상품 이름, 결제 타입
extension CardTransactionTableViewCell {

    private func setUpProductStackView() {
        addSubviewsOfProductStackView()
        setStyleOfProductStackView()
        setStyleOfProductStackView()
        setConstraintsOfProductStackView()
    }
    
    private func addSubviewsOfProductStackView() {
        [productNameLabel, transactionTypeLabel].forEach { productStackView.addArrangedSubview($0) }
    }
    
    private func setStyleOfProductStackView() {
        productStackView.backgroundColor = .clear
    }
    
    private func setConstraintsOfProductStackView() {
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
        ])
    }
    
}

// MARK: - Product Name Label: 상품 이름
extension CardTransactionTableViewCell {
    
    private func setUpProductNameLabel() {
        setStyleOfProductNameLabel()
    }
    
    private func setStyleOfProductNameLabel() {
        productNameLabel.backgroundColor = .clear
        productNameLabel.numberOfLines = 1
        productNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setContentOfProductNameLabel(to name: String) {
        productNameLabel.text = productName
    }
    
}

// MARK: - Transaction Type Label: 결제 타입
extension CardTransactionTableViewCell {
    
    private func setUpTransactionTypeLabel() {
        setStyleOfTransactionTypeLabel()
    }
    
    private func setStyleOfTransactionTypeLabel() {
        transactionTypeLabel.backgroundColor = .clear
        transactionTypeLabel.numberOfLines = 1
        transactionTypeLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    func setContentOfTransactionTypeLabel(to type: String) {
        let type = CardTransactionType(rawValue: type) ?? CardTransactionType.UNKNOWN
        transactionTypeLabel.text = type.description
        switch type {
        case .OK:
            transactionTypeLabel.textColor = .blue
        case .CANCEL:
            transactionTypeLabel.textColor = .red
        default:
            transactionTypeLabel.textColor = .gray
        }
    }

}

// MARK: - Date Label: 결제 일시
extension CardTransactionTableViewCell {
    
    private func setUpDateLabel() {
        setStyleOfDateLabel()
    }
    
    private func setStyleOfDateLabel() {
        dateLabel.backgroundColor = .clear
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .black
    }
    
    func setContentOfDateLabel(to date: String) {
        dateLabel.text = date
    }
    
}

// MARK: - Cost StackView: 결제 금액 제목, 결제 금액
extension CardTransactionTableViewCell {

    private func setUpCostStackView() {
        addSubviewsOfCostStackView()
        setStyleOfCostStackView()
        setStyleOfCostStackView()
        setConstraintsOfCostStackView()
    }
    
    private func addSubviewsOfCostStackView() {
        [costTitleLabel, costLabel].forEach { costStackView.addArrangedSubview($0) }
    }
    
    private func setStyleOfCostStackView() {
        costStackView.backgroundColor = .clear
    }
    
    private func setConstraintsOfCostStackView() {
        costStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            costStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            costStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
        ])
    }
    
}

// MARK: - Cost Title Label: 결제 금액 제목
extension CardTransactionTableViewCell {
    
    private func setUpCostTitleLabel() {
        setStyleOfCostTitleLabel()
        setContentOfCostTitleLabel(to: costTitle)
    }
    
    private func setStyleOfCostTitleLabel() {
        costTitleLabel.backgroundColor = .clear
        costTitleLabel.numberOfLines = 1
        costTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        costTitleLabel.textColor = .black
    }
    
    private func setContentOfCostTitleLabel(to title: String) {
        costTitleLabel.text = title
    }
    
}

// MARK: - Cost Label: 결제 금액
extension CardTransactionTableViewCell {
    
    private func setUpCostLabel() {
        setStyleOfCostLabel()
    }
    
    private func setStyleOfCostLabel() {
        costLabel.backgroundColor = .clear
        costLabel.numberOfLines = 1
        costLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        costLabel.textColor = .black
    }
    
    func setContentOfCostLabel(to cost: Int) {
        costLabel.text = costText(cost)
    }
    
}
