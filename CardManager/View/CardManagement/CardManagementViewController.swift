//
//  CardManagementViewController.swift
//  CardManager
//
//  Created by Apple on 2023/02/19.
//

import UIKit

import RxCocoa
import RxSwift

final class CardManagementViewController: UIViewController {
    
    // MARK: - UI
    private let cardNameTitleLabel = UILabel()
    private let cardNameTextField = UITextField()
    private let confirmButton = UIButton()
    
    // MARK: - Constants
    private var navigationTitle: String { return mode.rawValue }
    private var cardNameTitle = "카드 별명"
    private let cardNameTextFieldPlaceholder = "KB체크카드"
    private var confirmButtonTitle: String {
        if mode == .register {
            return "등록 완료"
        }
        else {
            return "수정 완료"
        }
    }
    private let cardNameTextFieldHeight: CGFloat = 50.0
    private let confirmButtonHeight: CGFloat = 50.0
    
    // MARK: - Intances
    private var mainViewController: MainViewController?
    private var viewModel: CardManagementViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private var mode: CardManagementType = .register
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setUpCardNameTitleLabel()
        setUpCardNameTextField()
        setUpConfirmButton()
    }
    
}


// MARK: - ViewController
extension CardManagementViewController {
    
    private func setUpViewController() {
        addSubviews()
        setStyleOfViewController()
        setNavigationController()
    }
    
    private func addSubviews() {
        [cardNameTitleLabel, cardNameTextField, confirmButton].forEach { view.addSubview($0) }
    }
    
    private func setStyleOfViewController() {
        view.backgroundColor = .white
    }
    
    private func setNavigationController() {
        navigationItem.title = navigationTitle
    }
    
    static func create(mainViewController: MainViewController, mode: CardManagementType, cardID: String? = nil) -> CardManagementViewController {
        let viewController = CardManagementViewController()
        viewController.mainViewController = mainViewController
        viewController.mode = mode
        let viewModel = CardManagementViewModel(cardID: cardID)
        viewController.viewModel = viewModel
        return viewController
    }
    
}

// MARK: - Card Name Title Label: 카드 별명 제목
extension CardManagementViewController {
    
    private func setUpCardNameTitleLabel() {
        setStyleOfCardNameTitleLabel()
        setConstraintsOfCardNameTitleLabel()
        setContentOfCardNameTitleLabel(to: cardNameTitle)
    }
    
    private func setStyleOfCardNameTitleLabel() {
        cardNameTitleLabel.textColor = .black
    }
    
    private func setConstraintsOfCardNameTitleLabel() {
        cardNameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardNameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            cardNameTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cardNameTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setContentOfCardNameTitleLabel(to title: String) {
        cardNameTitleLabel.text = cardNameTitle
    }
    
}

// MARK: - Card Name TextField: 카드 별명 입력창
extension CardManagementViewController: UITextFieldDelegate {
    
    private func setUpCardNameTextField() {
        setStyleOfCardNameTextField()
        setConstraintsOfCardNameTextField()
        setPlaceholderOfCardNameTextField(to: cardNameTextFieldPlaceholder)
        bindCardNameTextFieldDidChanged()
    }
    
    private func configureCardNameTextField() {
        cardNameTextField.delegate = self
    }
    
    private func setStyleOfCardNameTextField() {
        cardNameTextField.textColor = .black
        cardNameTextField.backgroundColor = .systemGray5
        cardNameTextField.layer.masksToBounds = true
        cardNameTextField.layer.cornerRadius = 5.0
        cardNameTextField.addPadding()
    }
    
    private func setConstraintsOfCardNameTextField() {
        cardNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardNameTextField.topAnchor.constraint(equalTo: cardNameTitleLabel.bottomAnchor, constant: 10),
            cardNameTextField.leadingAnchor.constraint(equalTo: cardNameTitleLabel.leadingAnchor),
            cardNameTextField.trailingAnchor.constraint(equalTo: cardNameTitleLabel.trailingAnchor),
            cardNameTextField.heightAnchor.constraint(equalToConstant: cardNameTextFieldHeight)
        ])
    }
    
    private func setPlaceholderOfCardNameTextField(to placeholder: String) {
        cardNameTextField.placeholder = placeholder
    }
    
    private func bindCardNameTextFieldDidChanged() {
        cardNameTextField.rx.text
            .subscribe(onNext: { [weak self] changedText in
                guard let self = self else { return }
                guard let text = changedText else { return }
                if text.count >= 2 {
                    self.turnConfirmButton(true)
                }
                else {
                    self.turnConfirmButton(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Confirm Button: 등록(수정) 완료 버튼
extension CardManagementViewController {
    
    private func setUpConfirmButton() {
        setStyleOfConfirmButton()
        setConstraintsOfConfirmButton()
        setTitleOfConfirmButton(to: confirmButtonTitle)
        bindConfirmButtonDidTapped()
    }
    
    private func setStyleOfConfirmButton() {
        confirmButton.tintColor = .black
        confirmButton.backgroundColor = .lightGray
    }
    
    private func setConstraintsOfConfirmButton() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: confirmButtonHeight)
        ])
    }
    
    private func setTitleOfConfirmButton(to title: String) {
        confirmButton.setTitle(title, for: .normal)
    }
    
    private func turnConfirmButton(_ isEnable: Bool) {
        confirmButton.isEnabled = isEnable
        if isEnable {
            confirmButton.backgroundColor = Constants.Color.base
        }
        else {
            confirmButton.backgroundColor = .lightGray
        }
    }
    
    private func bindConfirmButtonDidTapped() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let cardName = self.cardNameTextField.text else { return }
                switch self.mode {
                case .register:
                    self.registerCard(cardName: cardName)
                case .edit:
                    self.renameCard(cardName: cardName)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func registerCard(cardName: String) {
        LoadingIndicator.showLoading()
        viewModel?.createCard(name: cardName, errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: { [weak self] in
            guard let self = self else { return }
            self.update()
        })
    }
    
    private func renameCard(cardName: String) {
        LoadingIndicator.showLoading()
        viewModel?.renameCard(name: cardName, errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: { [weak self] in
            guard let self = self else { return }
            self.update()
        })
    }
    
    private func update() {
        self.mainViewController?.viewModel.fetchCardList(errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            LoadingIndicator.hideLoading()
        })
    }
    
}
