//
//  MainViewController.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import UIKit

import RxCocoa
import RxSwift

final class MainViewController: UIViewController {
    
    // MARK: - UI
    private let cardListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = UIScreen.main.bounds.width / 3 / 3
        let width: CGFloat = UIScreen.main.bounds.width * 2 / 3
        let height: CGFloat = UIScreen.main.bounds.width * 2 / 3 / 1.58
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing * 3 / 2, bottom: 0, right: spacing * 3 / 2)
        layout.itemSize = CGSize(width: width, height: height)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let pageControl = UIPageControl()
    private let cardTransactionContainerView = UIView()
    private let monthContainerView = UIView()
    private let monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    private let monthLabel = UILabel()
    private let monthSelectionButton = UIButton()
    private let cardTransactionTableView = UITableView()
    private let noCardTransactionContainerView = UIView()
    private let noCardTransactionLabel = UILabel()
    private lazy var datePickerView  = UIPickerView.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: datePickerViewHeight))
    private lazy var dateToolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: toolBarHeight))
    private lazy var cardManagementTableView = UITableView.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: cardManagementTableViewHeight))
    private lazy var cardManagementToolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: toolBarHeight))
    private let coverView = UIView()
    
    // MARK: - Constants
    private let navigationTitle = "결제 수단 관리"
    private let backBarButtonItemTitle = ""
    private let noCardTransactionTitle = "결제 기록이 없습니다."
    private let okButtonTitle = "확인"
    private let cancelButtonTitle = "취소"
    private let dateToolbarTitle = "조회 월 선택"
    private let cardDeletionAlertTitle = "카드 삭제"
    private let cardDeletionAlertMessage = "카드를 삭제하시겠습니까?"
    private let deletionButtonTitle = "삭제"
    private let cardManagementToolbarTitle = "카드 설정"
    private let monthLabelText = {(year: Int, month: Int) -> String in
        return "\(year)-\(month)"
    }
    private let cardManagementMenu = ["카드 삭제", "닉네임 변경하기"]
    private let monthSelectionButtonImage = UIImage(systemName: "chevron.down.circle.fill")
    private let cardListCollectionViewHeight: CGFloat = UIScreen.main.bounds.width * 2 / 3 / 1.58 + 10
    private let cornerRadius: CGFloat = 10.0
    private let coverViewAlpha = 0.2
    private let datePickerViewHeight: CGFloat = 300.0
    private let toolBarHeight: CGFloat = 50.0
    private let cardManagementTableViewHeight: CGFloat = 250.0
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    private let monthContainerViewHeight: CGFloat = 50.0
    private let noCardTransactionContainerViewHeight: CGFloat = 100.0
    private let allYears: [Int] = Array(2022...Calendar.current.component(.year, from: Date()))
    private let allMonths: [Int] = Array(1...12)
    private let todayYear = Calendar.current.component(.year, from: Date())
    private let todayMonth = Calendar.current.component(.month, from: Date())
    
    // MARK: - Instances
    let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setUpViewModel()
        setUpCardListCollectionView()
        setUpPageControll()
        setUpCardTransactionContainerView()
        setUpMonthContainerView()
        setUpMonthStackView()
        setUpMonthLabel()
        setUpMonthSelectionButton()
        setUpCardTransactionTableView()
        setUpNoCardTransactionContainerView()
        setUpNoCardTransactionLabel()
        setUpDatePickerView()
        setUpDateToolbar()
        setUpCardManagementTableView()
        setUpCardManagementToolbar()
        setUpCoverView()
    }
    
}

// MARK: - ViewController
extension MainViewController {
    
    private func setUpViewController() {
        addSubviews()
        setStyleOfViewController()
        setNavigationController()
    }
    
    private func addSubviews() {
        [cardListCollectionView, pageControl, cardTransactionContainerView, coverView, datePickerView, dateToolbar, cardManagementTableView, cardManagementToolbar].forEach { view.addSubview($0) }
    }
    
    private func setStyleOfViewController() {
        view.backgroundColor = Constants.Color.background
    }
    
    private func setNavigationController() {
        navigationItem.title = navigationTitle
        let backBarButtonItem = UIBarButtonItem(title: backBarButtonItemTitle, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
}

// MARK: - ViewModel
extension MainViewController {
    
    private func setUpViewModel() {
        LoadingIndicator.showLoading()
        viewModel.fetchCardList(errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: {
            LoadingIndicator.hideLoading()
        })
    }
    
}

// MARK: - Card List CollectionView: 카드 목록
extension MainViewController: UICollectionViewDelegate, CardListCollectionViewCellDelegate {
    
    private func setUpCardListCollectionView() {
        setConstraintsOfCardListCollectionView()
        configureCardListCollectionView()
        setStyleOfCardListCollectionView()
        bindCardListCollectionView()
    }
    
    private func configureCardListCollectionView() {
        cardListCollectionView.register(CardListCollectionViewCell.self, forCellWithReuseIdentifier: CardListCollectionViewCell.identifier)
        cardListCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        cardListCollectionView.isPagingEnabled = false
        cardListCollectionView.decelerationRate = .fast
        cardListCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setStyleOfCardListCollectionView() {
        cardListCollectionView.backgroundColor = .clear
    }
    
    private func setConstraintsOfCardListCollectionView() {
        cardListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            cardListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            cardListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            cardListCollectionView.heightAnchor.constraint(equalToConstant: cardListCollectionViewHeight)
        ])
    }
    
    private func bindCardListCollectionView() {
        viewModel.cardListSubject
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] cardList in
                guard let self = self else { return }
                self.setNumberOfPages(to: cardList.count)
            })
            .bind(to: cardListCollectionView.rx.items(cellIdentifier: CardListCollectionViewCell.identifier, cellType: CardListCollectionViewCell.self)) { index, item, cell in
                cell.delegate = self
                cell.setCard(isEmptyCard: (item.id == Constants.Id.emptyCard))
                cell.setContentOfCarNameLabel(to: item.name)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Delegate Methods
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != cardListCollectionView { return }
        guard let layout = cardListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidth
        var index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex)) < viewModel.cardList.count ? Int(ceil(estimatedIndex)) : viewModel.cardList.count - 1
        } else {
            index = Int(floor(estimatedIndex)) >= 0 ? Int(floor(estimatedIndex)) : 0
        }
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
        LoadingIndicator.showLoading()
        setCurrentPage(to: index)
        viewModel.setCurrentCardIndex(to: index)
        viewModel.setCurrentCardID(to: viewModel.cardList[viewModel.currentCardIndex].id)
        viewModel.fetchCardTransaction(errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: {
            LoadingIndicator.hideLoading()
        })
    }
    
    func cardRegistrationButtonDidTapped() {
        navigationController?.pushViewController(CardManagementViewController.create(mainViewController: self, mode: .register), animated: true)
    }
    
    func cardManagementButtonDidTapped() {
        turnOnCardManagement()
    }
    
}


// MARK: - Page Control: 카드 목록 페이지 표시
extension MainViewController {
    
    private func setUpPageControll() {
        setStyleOfPageControll()
        setConstraintsOfPageControll()
    }
    
    private func setStyleOfPageControll() {
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = Constants.Color.card
    }
    
    private func setConstraintsOfPageControll() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: cardListCollectionView.bottomAnchor, constant: 10)
        ])
    }
    
    func setCurrentPage(to page: Int) {
        pageControl.currentPage = page
    }
    
    private func setNumberOfPages(to numbers: Int) {
        pageControl.numberOfPages = numbers
    }
    
}


// MARK: - Card Transaction Container View: 날짜 선택, 카드 결제 내역
extension MainViewController {
    
    private func setUpCardTransactionContainerView() {
        addSubviewsOfCardTransactionContainerView()
        setStyleOfCardTransactionContainerView()
        setConstraintsOfCardTransactionContainerView()
    }
    
    private func addSubviewsOfCardTransactionContainerView() {
        [monthContainerView, cardTransactionTableView, noCardTransactionContainerView].forEach { cardTransactionContainerView.addSubview($0) }
    }
    
    private func setStyleOfCardTransactionContainerView() {
        cardTransactionContainerView.backgroundColor = .clear
    }
    
    private func setConstraintsOfCardTransactionContainerView() {
        cardTransactionContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardTransactionContainerView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            cardTransactionContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cardTransactionContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cardTransactionContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
}

// MARK: - Month Container View: 날짜 선택
extension MainViewController {
    
    private func setUpMonthContainerView() {
        addSubviewsOfMonthContainerView()
        setStyleOfMonthContainerView()
        setConstraintsOfMonthContainerView()
    }
    
    private func addSubviewsOfMonthContainerView() {
        [monthStackView].forEach { monthContainerView.addSubview($0) }
    }
    
    private func setStyleOfMonthContainerView() {
        monthContainerView.backgroundColor = .white
        monthContainerView.layer.masksToBounds = true
        monthContainerView.layer.cornerRadius = cornerRadius
    }
    
    private func setConstraintsOfMonthContainerView() {
        monthContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthContainerView.topAnchor.constraint(equalTo: cardTransactionContainerView.topAnchor),
            monthContainerView.leadingAnchor.constraint(equalTo: cardTransactionContainerView.leadingAnchor),
            monthContainerView.trailingAnchor.constraint(equalTo: cardTransactionContainerView.trailingAnchor),
            monthContainerView.heightAnchor.constraint(equalToConstant: monthContainerViewHeight)
        ])
    }
    
}

// MARK: - Month StackView: 날짜 라벨, 날짜 선택 버튼
extension MainViewController {
    
    private func setUpMonthStackView() {
        addSubviewsOfMonthStackView()
        setStyleOfMonthStackView()
        setConstraintsOfMonthStackView()
    }
    
    private func addSubviewsOfMonthStackView() {
        [monthLabel, monthSelectionButton].forEach { monthStackView.addArrangedSubview($0) }
    }
    
    private func setStyleOfMonthStackView() {
        monthStackView.backgroundColor = .clear
    }
    
    private func setConstraintsOfMonthStackView() {
        monthStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthStackView.centerXAnchor.constraint(equalTo: monthContainerView.centerXAnchor),
            monthStackView.centerYAnchor.constraint(equalTo: monthContainerView.centerYAnchor)
        ])
    }
    
}

// MARK: - Month Label: 날짜 라벨
extension MainViewController {
    
    private func setUpMonthLabel() {
        setStyleOfMonthLabel()
        setContentOfMonthLabel()
    }
    
    private func setStyleOfMonthLabel() {
        monthLabel.backgroundColor = .clear
        monthLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private func setContentOfMonthLabel() {
        monthLabel.text = monthLabelText(viewModel.selectedYear, viewModel.selectedMonth)
    }
    
}

// MARK: - Month Selection Button: 날짜 선택 버튼
extension MainViewController {
    
    private func setUpMonthSelectionButton() {
        setStyleOfMonthSelectionButton()
        bindMonthSelectionButtonDidTapped()
    }
    
    private func setStyleOfMonthSelectionButton() {
        monthSelectionButton.backgroundColor = .clear
        monthSelectionButton.tintColor = .lightGray
        monthSelectionButton.setImage(monthSelectionButtonImage, for: .normal)
    }
    
    private func bindMonthSelectionButtonDidTapped() {
        monthSelectionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.turnOnDateSelection()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Card Transaction TableView: 카드 결제 내역
extension MainViewController {
    
    private func setUpCardTransactionTableView() {
        configureCardTransactionTableView()
        setStyleOfCardTransactionTableView()
        setConstraintsOfCardTransactionTableView()
        bindCardTransactionTableView()
    }
    
    private func configureCardTransactionTableView() {
        cardTransactionTableView.register(CardTransactionTableViewCell.self, forCellReuseIdentifier: CardTransactionTableViewCell.identifier)
    }
    
    private func setStyleOfCardTransactionTableView() {
        cardTransactionTableView.backgroundColor = .clear
        cardTransactionTableView.allowsSelection = false
        cardTransactionTableView.separatorStyle = .none
    }
    
    private func setConstraintsOfCardTransactionTableView() {
        cardTransactionTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardTransactionTableView.topAnchor.constraint(equalTo: monthContainerView.bottomAnchor, constant: 20),
            cardTransactionTableView.leadingAnchor.constraint(equalTo: cardTransactionContainerView.leadingAnchor),
            cardTransactionTableView.trailingAnchor.constraint(equalTo: cardTransactionContainerView.trailingAnchor),
            cardTransactionTableView.bottomAnchor.constraint(equalTo: cardTransactionContainerView.bottomAnchor)
        ])
    }
    
    private func bindCardTransactionTableView() {
        viewModel.cardTransactionListSubject
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] cardTransactionList in
                guard let self = self else { return }
                self.displayCardTransaction(isCardTransactionListEmpty: cardTransactionList.isEmpty)
            })
            .bind(to: cardTransactionTableView.rx.items(cellIdentifier: CardTransactionTableViewCell.identifier, cellType: CardTransactionTableViewCell.self)) { index, item, cell in
                cell.setContent(productName: item.product.name, date: item.date, cost: item.product.cost, transactionType: item.type)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Card Transaction: 카드 결제 내역 관련 뷰 or 카드 결제 내역이 없을 때의 뷰 노출
extension MainViewController {
    
    private func displayCardTransaction(isCardTransactionListEmpty: Bool) {
        if viewModel.currentCardID == Constants.Id.emptyCard {
            cardTransactionContainerView.isHidden = true
            monthContainerView.isHidden = true
            noCardTransactionContainerView.isHidden = true
        }
        else {
            cardTransactionContainerView.isHidden = false
            monthContainerView.isHidden = false
            if isCardTransactionListEmpty {
                noCardTransactionContainerView.isHidden = false
                cardTransactionTableView.isHidden = true
            }
            else {
                noCardTransactionContainerView.isHidden = true
                cardTransactionTableView.isHidden = false
            }
        }
    }
    
}

// MARK: - No Card Transaction Container View: 카드 결제 내역이 없을 때
extension MainViewController {
    
    private func setUpNoCardTransactionContainerView() {
        addSubviewsOfNoCardTransactionContainerView()
        setStyleOfNoCardTransactionContainerView()
        setConstraintsOfNoCardTransactionContainerView()
    }
    
    private func addSubviewsOfNoCardTransactionContainerView() {
        [noCardTransactionLabel].forEach { noCardTransactionContainerView.addSubview($0) }
    }
    
    private func setStyleOfNoCardTransactionContainerView() {
        noCardTransactionContainerView.backgroundColor = .white
        noCardTransactionContainerView.layer.masksToBounds = true
        noCardTransactionContainerView.layer.cornerRadius = cornerRadius
    }
    
    private func setConstraintsOfNoCardTransactionContainerView() {
        noCardTransactionContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noCardTransactionContainerView.topAnchor.constraint(equalTo: cardTransactionTableView.topAnchor),
            noCardTransactionContainerView.leadingAnchor.constraint(equalTo: cardTransactionContainerView.leadingAnchor),
            noCardTransactionContainerView.trailingAnchor.constraint(equalTo: cardTransactionContainerView.trailingAnchor),
            noCardTransactionContainerView.heightAnchor.constraint(equalToConstant: noCardTransactionContainerViewHeight)
        ])
    }
    
}

// MARK: - No Card Transaction Label: 카드 결제 내역이 없을 때 안내 라벨
extension MainViewController {
    
    private func setUpNoCardTransactionLabel() {
        setStyleOfNoCardTransactionLabel()
        setConstraintsOfNoCardTransactionLabel()
        setContentOfNoCardTransactionLabel(to: noCardTransactionTitle)
    }
    
    private func setStyleOfNoCardTransactionLabel() {
        noCardTransactionLabel.textColor = .lightGray
    }
    
    private func setConstraintsOfNoCardTransactionLabel() {
        noCardTransactionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noCardTransactionLabel.centerXAnchor.constraint(equalTo: noCardTransactionContainerView.centerXAnchor),
            noCardTransactionLabel.centerYAnchor.constraint(equalTo: noCardTransactionContainerView.centerYAnchor)
        ])
    }
    
    private func setContentOfNoCardTransactionLabel(to title: String) {
        noCardTransactionLabel.text = title
    }
    
}

// MARK: - Date PickerView: 날짜 선택 버튼 클릭 시 노출되는 피커뷰
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setUpDatePickerView() {
        configureDatePickerView()
        setStyleOfDatePickerView()
        setInitialRowOfDatePickerView()
    }
    
    func configureDatePickerView() {
        datePickerView.delegate = self
        datePickerView.dataSource = self
    }
    
    func setStyleOfDatePickerView() {
        datePickerView.isHidden = true
        datePickerView.backgroundColor = .white
        datePickerView.setValue(UIColor.black, forKey: Constants.Key.textColor)
        datePickerView.autoresizingMask = .flexibleWidth
        datePickerView.contentMode = .center
        datePickerView.layer.masksToBounds = true
        datePickerView.layer.cornerRadius = 10.0
    }
    
    func setInitialRowOfDatePickerView() {
        datePickerView.selectRow(allYears.count - 1, inComponent: 0, animated: true)
        datePickerView.selectRow(todayMonth - 1, inComponent: 1, animated: true)
    }
    
    // MARK: - Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return allYears.count
        case 1:
            return allMonths.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(allYears[row])
        case 1:
            return String(allMonths[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            viewModel.setSelectedYear(to: allYears[row])
        case 1:
            viewModel.setSelectedMonth(to: allMonths[row])
        default:
            break
        }
        
        if (todayYear == viewModel.selectedYear) && (todayMonth < viewModel.selectedMonth) {
            pickerView.selectRow(todayMonth - 1, inComponent: 1, animated: true)
            viewModel.setSelectedMonth(to: todayMonth)
        }
    }
    
}

// MARK: - Date Toolbar: 날짜 선택 버튼 클릭 시 노출되는 피커뷰의 툴바
extension MainViewController {
    
    func setUpDateToolbar() {
        setStyleOfDateToolbar()
        setBarButtonItemsOfDateToolbar()
    }
    
    func setStyleOfDateToolbar() {
        dateToolbar.isHidden = true
        dateToolbar.barTintColor = .white
        dateToolbar.layer.masksToBounds = true
        dateToolbar.layer.cornerRadius = 10.0
        dateToolbar.isUserInteractionEnabled = true
        dateToolbar.isTranslucent = false
    }
    
    func setBarButtonItemsOfDateToolbar() {
        let cancelButton = UIBarButtonItem(title: cancelButtonTitle, style: .done, target: self, action: #selector(cancelButtonOfDateToolbarDidTapped))
        cancelButton.tintColor = .black
        let okButton = UIBarButtonItem(title: okButtonTitle, style: .done, target: self, action: #selector(okButtonOfDateToolbarDidTapped))
        okButton.tintColor = .black
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = dateToolbarTitle
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        let titleBarButton = UIBarButtonItem(customView: titleLabel)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        dateToolbar.setItems([cancelButton, space, titleBarButton, space, okButton], animated: true)
    }
    
    // MARK: - Bar Button Action
    @objc func okButtonOfDateToolbarDidTapped() {
        LoadingIndicator.showLoading()
        turnOffDateSelection()
        setContentOfMonthLabel()
        viewModel.fetchCardTransaction(errorHandler: { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.present(ErrorAlertManager.alert(with: error), animated: true)
            }
        }, completionHandler: {
            LoadingIndicator.hideLoading()
        })
    }
    
    @objc func cancelButtonOfDateToolbarDidTapped() {
        turnOffDateSelection()
    }
    
}

// MARK: - Date Selection: 날짜 선택 뷰 노출 or 숨기기
extension MainViewController {
    
    private func turnOnDateSelection() {
        self.datePickerView.isHidden = false
        self.dateToolbar.isHidden = false
        self.coverView.isHidden = false
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.screenHeight - self.datePickerViewHeight, width: self.screenWidth, height: self.datePickerViewHeight)
            self.dateToolbar.frame = CGRect(x: 0, y: self.screenHeight - self.datePickerViewHeight, width: self.screenWidth, height: self.toolBarHeight)
            self.coverView.alpha = self.coverViewAlpha
        }, completion: nil)
    }
    
    private func turnOffDateSelection() {
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.datePickerViewHeight)
            self.dateToolbar.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.toolBarHeight)
            self.coverView.alpha = 0
        }) { _ in
            self.datePickerView.isHidden = true
            self.dateToolbar.isHidden = true
            self.coverView.isHidden = true
        }
    }
    
}

// MARK: - Card Management TableView: 카드 관리 메뉴(삭제, 닉네임 변경)
extension MainViewController {
    
    private func setUpCardManagementTableView() {
        configureCardManagementTableView()
        setStyleOfCardManagementTableView()
        bindCardManagementTableView()
        bindCardManagementTableViewRowDidSelected()
    }
    
    private func configureCardManagementTableView() {
        cardManagementTableView.register(CardManagementTableViewCell.self, forCellReuseIdentifier: CardManagementTableViewCell.identifier)
        cardManagementTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setStyleOfCardManagementTableView() {
        cardManagementTableView.separatorStyle = .none
    }
    
    private func bindCardManagementTableView() {
        Observable.of(cardManagementMenu)
            .bind(to: cardManagementTableView.rx.items(cellIdentifier: CardManagementTableViewCell.identifier, cellType: CardManagementTableViewCell.self)) { index, item, cell in
                cell.setContentOfMenuLabel(to: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCardManagementTableViewRowDidSelected() {
        cardManagementTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.row {
                case 0:
                    self.cardDeletionRowDidTapped()
                case 1:
                    self.cardRenameRowDidTapped()
                default:
                    return
                }
                self.cardManagementTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func cardDeletionRowDidTapped() {
        self.alertCardDeletion()
        self.cancelButtonOfCardManagementToolbarDidTapped()
    }
    
    private func cardRenameRowDidTapped() {
        self.navigationController?.pushViewController(CardManagementViewController.create(mainViewController: self, mode: .edit, cardID: self.viewModel.currentCardID), animated: true)
        self.cancelButtonOfCardManagementToolbarDidTapped()
    }
    
    private func alertCardDeletion() {
        let alert = UIAlertController(title: cardDeletionAlertTitle, message: cardDeletionAlertMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: deletionButtonTitle, style: UIAlertAction.Style.default)
        { _ in
            LoadingIndicator.showLoading()
            self.viewModel.deleteCard(errorHandler: { error in
                guard let error = error else { return }
                DispatchQueue.main.async {
                    self.present(ErrorAlertManager.alert(with: error), animated: true)
                }
            }, completionHandler: {
                LoadingIndicator.hideLoading()
            })
        }
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: nil)
        deleteAction.setValue(UIColor.red, forKey: Constants.Key.titleTextColor)
        cancelAction.setValue(UIColor.black, forKey: Constants.Key.titleTextColor)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Card Management Toolbar: 카드 관리 메뉴 툴바
extension MainViewController {
    
    func setUpCardManagementToolbar() {
        setStyleOfCardManagementToolbar()
        setBarButtonItemsOfCardManagementToolbar()
    }
    
    func setStyleOfCardManagementToolbar() {
        cardManagementToolbar.isHidden = true
        cardManagementToolbar.barTintColor = .white
        cardManagementToolbar.layer.masksToBounds = true
        cardManagementToolbar.layer.cornerRadius = 10.0
        cardManagementToolbar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        cardManagementToolbar.isUserInteractionEnabled = true
        cardManagementToolbar.isTranslucent = false
    }
    
    func setBarButtonItemsOfCardManagementToolbar() {
        let cancelButton = UIBarButtonItem(title: cancelButtonTitle, style: .done, target: self, action: #selector(cancelButtonOfCardManagementToolbarDidTapped))
        cancelButton.tintColor = .black
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = cardManagementToolbarTitle
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        let titleBarButton = UIBarButtonItem(customView: titleLabel)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        cardManagementToolbar.setItems([cancelButton, space, titleBarButton, space], animated: true)
    }
    
    // MARK: - Bar Button Action
    @objc func cancelButtonOfCardManagementToolbarDidTapped() {
        turnOffCardManagement()
    }
    
}

// MARK: - Card Management: 카드 관리 메뉴 노출 or 숨기기
extension MainViewController {
    
    private func turnOnCardManagement() {
        cardManagementTableView.isHidden = false
        cardManagementToolbar.isHidden = false
        coverView.isHidden = false
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.cardManagementTableView.frame = CGRect(x: 0, y: self.screenHeight - self.cardManagementTableViewHeight, width: self.screenHeight, height: self.cardManagementTableViewHeight)
            self.cardManagementToolbar.frame = CGRect(x: 0, y: self.screenHeight - (self.cardManagementTableViewHeight + self.toolBarHeight), width: self.screenWidth, height: self.toolBarHeight)
            self.coverView.alpha = self.coverViewAlpha
        }, completion: nil)
    }
    
    private func turnOffCardManagement() {
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            self.cardManagementTableView.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenHeight, height: self.cardManagementTableViewHeight)
            self.cardManagementToolbar.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenHeight, height: self.toolBarHeight)
            self.coverView.alpha = 0
        }) { _ in
            self.cardManagementTableView.isHidden = true
            self.cardManagementToolbar.isHidden = true
            self.coverView.isHidden = true
        }
    }
    
}

// MARK: - Cover View: 날짜 피커뷰 또는 카드 관리 메뉴 노출 시 사용되는 커버뷰
extension MainViewController {
    
    private func setUpCoverView() {
        setStyleOfCoverView()
    }
    
    private func setStyleOfCoverView() {
        coverView.backgroundColor = .black
        coverView.alpha = 0
        coverView.frame = view.frame
        coverView.isHidden = true
    }
    
}
