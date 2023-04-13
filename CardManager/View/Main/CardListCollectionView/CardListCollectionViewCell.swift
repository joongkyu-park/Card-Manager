//
//  CardListCollectionViewCell.swift
//  CardManager
//
//  Created by Apple on 2023/02/19.
//

import UIKit

import RxCocoa
import RxSwift

final class CardListCollectionViewCell: UICollectionViewCell {
 
    // MARK: - UI
    private let cardContainerView = UIView()
    private let cardNameLabel = UILabel()
    private let managementButton = UIButton()
    private let cardRegistrationContainerView = UIView()
    private let cardRegistrationButton = UIButton()
    private let cardRegistrationIconImageView = UIImageView()
    private let cardRegistrationTitleLabel = UILabel()
    
    // MARK: - Constants
    static let identifier = "CardListCollectionViewCell"
    private let cardRegistrationTitle = "결제 카드 추가하기"
    private let managementButtonImage = UIImage(systemName: "ellipsis")
    private let cardRegistrationIconImage = UIImage(systemName: "plus")
    private let cornerRadius: CGFloat = 10.0
    private let cardRegistrationIconImageViewSide: CGFloat = 30.0
    private let shadowOffset: CGSize = CGSize(width: 3.0, height: 3.0)
    private let shadowRadius: CGFloat = 2.0
    private let shadowOpacity: Float = 0.2
    private var managementButtonWidth: CGFloat {
        get {
            return bounds.width / 10
        }
    }
    private var managementButtonHeight: CGFloat {
        get {
            return bounds.width / 10 / 2
        }
    }
    
    // MARK: - Properties
    weak var delegate: CardListCollectionViewCellDelegate?
    
    // MARK: - Instances
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
        setUpCardContainerView()
        setUpCardNameLabel()
        setUpManagementButton()
        setUpCardRegistrationContainerView()
        setUpCardRegistrationButton()
        setUpCardRegistrationIconImageView()
        setUpCardRegistrationTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Cell
extension CardListCollectionViewCell {
    
    private func setUpCell() {
        addSubviews()
        setStyleOfCell()
        setSubviewsInitialState()
    }
    
    private func addSubviews() {
        [cardContainerView, cardRegistrationContainerView].forEach { addSubview($0) }
    }
    
    private func setStyleOfCell() {
        backgroundColor = .clear
    }
    
    private func setSubviewsInitialState() {
        cardRegistrationContainerView.isHidden = true
    }
    
    func setCard(isEmptyCard: Bool) {
        if isEmptyCard {
            cardContainerView.isHidden = true
            cardRegistrationContainerView.isHidden = false
        }
        else {
            cardContainerView.isHidden = false
            cardRegistrationContainerView.isHidden = true
        }
    }
    
}

// MARK: - Card Container View: 카드 뷰
extension CardListCollectionViewCell {
    
    private func setUpCardContainerView() {
        addSubviewsOfCardContainerView()
        setStyleOfCardContainerView()
        setConstraintsOfCardContainerView()
    }
    
    private func addSubviewsOfCardContainerView() {
        [cardNameLabel, managementButton].forEach { cardContainerView.addSubview($0) }
    }
    
    private func setStyleOfCardContainerView() {
        cardContainerView.backgroundColor = Constants.Color.card
        cardContainerView.layer.cornerRadius = cornerRadius
        cardContainerView.layer.shadowOffset = shadowOffset
        cardContainerView.layer.shadowRadius = shadowRadius
        cardContainerView.layer.shadowOpacity = shadowOpacity
        cardContainerView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    private func setConstraintsOfCardContainerView() {
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

// MARK: - Card Name Label: 카드 이름
extension CardListCollectionViewCell {
    
    private func setUpCardNameLabel() {
        setStyleOfCardNameLabel()
        setConstraintsOfCardNameLabel()
    }
    
    private func setStyleOfCardNameLabel() {
        cardNameLabel.textColor = Constants.Color.label
        cardNameLabel.textAlignment = .center
        cardNameLabel.numberOfLines = 1
    }
    
    private func setConstraintsOfCardNameLabel() {
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardNameLabel.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            cardNameLabel.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            cardNameLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            cardNameLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
        ])
    }
    
    func setContentOfCarNameLabel(to name: String) {
        cardNameLabel.text = name
    }
    
}

// MARK: - Management Button: 더보기 버튼(점세개)
extension CardListCollectionViewCell {
    
    private func setUpManagementButton() {
        setStyleOfManagementButton()
        setConstraintsOfManagementButton()
        bindManagementButtonDidTapped()
    }
    
    private func setStyleOfManagementButton() {
        managementButton.setImage(managementButtonImage, for: .normal)
        managementButton.tintColor = Constants.Color.label
        managementButton.contentMode = .scaleToFill
    }
    
    private func setConstraintsOfManagementButton() {
        managementButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            managementButton.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            managementButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -20),
            managementButton.widthAnchor.constraint(equalToConstant: managementButtonWidth),
            managementButton.heightAnchor.constraint(equalToConstant: managementButtonHeight)
        ])
    }
    
    private func bindManagementButtonDidTapped() {
        managementButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.cardManagementButtonDidTapped()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Card Registration Container View: 카드 등록 뷰
extension CardListCollectionViewCell {
    
    private func setUpCardRegistrationContainerView() {
        addSubviewsOfCardRegistrationContainerView()
        setStyleOfCardRegistrationContainerView()
        setConstraintsOfCardRegistrationContainerView()
    }
    
    private func addSubviewsOfCardRegistrationContainerView() {
        [cardRegistrationButton, cardRegistrationIconImageView, cardRegistrationTitleLabel].forEach { cardRegistrationContainerView.addSubview($0) }
    }
    
    private func setStyleOfCardRegistrationContainerView() {
        cardRegistrationContainerView.backgroundColor = .white
        cardRegistrationContainerView.layer.cornerRadius = cornerRadius
        setBorderOfCardRegistrationContainerView()
    }
    
    private func setBorderOfCardRegistrationContainerView() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.lineDashPattern = [6,3]
        borderLayer.lineWidth = 2
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        cardRegistrationContainerView.layer.addSublayer(borderLayer)
    }
    
    private func setConstraintsOfCardRegistrationContainerView() {
        cardRegistrationContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardRegistrationContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cardRegistrationContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            cardRegistrationContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cardRegistrationContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

// MARK: Card Registration Button: 카드 등록 버튼
extension CardListCollectionViewCell {
    
    private func setUpCardRegistrationButton() {
        setStyleOfCardRegistrationButton()
        setConstraintsOfCardRegistrationButton()
        bindCardRegistrationButtonDidTapped()
    }

    private func setStyleOfCardRegistrationButton() {
        cardRegistrationButton.backgroundColor = .clear
    }
    
    private func setConstraintsOfCardRegistrationButton() {
        cardRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardRegistrationButton.topAnchor.constraint(equalTo: cardRegistrationContainerView.topAnchor),
            cardRegistrationButton.bottomAnchor.constraint(equalTo: cardRegistrationContainerView.bottomAnchor),
            cardRegistrationButton.leadingAnchor.constraint(equalTo: cardRegistrationContainerView.leadingAnchor),
            cardRegistrationButton.trailingAnchor.constraint(equalTo: cardRegistrationContainerView.trailingAnchor)
        ])
    }
    
    private func bindCardRegistrationButtonDidTapped() {
        cardRegistrationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.cardRegistrationButtonDidTapped()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Card Registration Icon ImageView: 카드 등록 뷰에 사용되는 이미지(플러스)
extension CardListCollectionViewCell {
    
    private func setUpCardRegistrationIconImageView() {
        setStyleOfCardRegistrationIconImageView()
        setConstraintsOfCardRegistrationIconImageView()
    }

    private func setStyleOfCardRegistrationIconImageView() {
        cardRegistrationIconImageView.image = cardRegistrationIconImage
        cardRegistrationIconImageView.tintColor = .lightGray
    }
    
    private func setConstraintsOfCardRegistrationIconImageView() {
        cardRegistrationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardRegistrationIconImageView.centerXAnchor.constraint(equalTo: cardRegistrationContainerView.centerXAnchor),
            cardRegistrationIconImageView.centerYAnchor.constraint(equalTo: cardRegistrationContainerView.centerYAnchor, constant: -10),
            cardRegistrationIconImageView.heightAnchor.constraint(equalToConstant: cardRegistrationIconImageViewSide),
            cardRegistrationIconImageView.widthAnchor.constraint(equalToConstant: cardRegistrationIconImageViewSide)
        ])
    }
    
}

// MARK: Card Registration Title Label: 카드 등록 안내 라벨
extension CardListCollectionViewCell {
    
    private func setUpCardRegistrationTitleLabel() {
        setStyleOfCardRegistrationTitleLabel()
        setConstraintsOfCardRegistrationTitleLabel()
        setContentOfCardRegistrationTitleLabel(to: cardRegistrationTitle)
    }

    private func setStyleOfCardRegistrationTitleLabel() {
        cardRegistrationTitleLabel.textColor = .lightGray
    }
    
    private func setConstraintsOfCardRegistrationTitleLabel() {
        cardRegistrationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardRegistrationTitleLabel.centerXAnchor.constraint(equalTo: cardRegistrationContainerView.centerXAnchor),
            cardRegistrationTitleLabel.topAnchor.constraint(equalTo: cardRegistrationIconImageView.bottomAnchor, constant: 10)
        ])
    }

    private func setContentOfCardRegistrationTitleLabel(to title: String) {
        cardRegistrationTitleLabel.text = title
    }
    
}
