//
//  MainViewModel.swift
//  CardManager
//
//  Created by Apple on 2023/02/22.
//

import Foundation

import RxSwift

final class MainViewModel {
    
    // MARK: - Observables
    private(set) var cardListSubject = PublishSubject<[Card]>()
    private(set) var cardTransactionListSubject = PublishSubject<[CardTransaction]>()
    
    // MARK: - Properties
    private(set) var cardList: [Card] = []
    private(set) var currentCardIndex = 0
    private(set) var selectedYear = Calendar.current.component(.year, from: Date())
    private(set) var selectedMonth = Calendar.current.component(.month, from: Date())
    private var month: String {
        return "\(selectedYear)-\(String(format: "%02d", selectedMonth))"
    }
    private(set) var cardTransactionList: [CardTransaction] = []
    private(set) var currentCardID = Constants.Id.emptyCard
    
    // MARK: - Instances
    private let disposeBag = DisposeBag()
    
}

// MARK: - REST API
extension MainViewModel {
    
    // MARK: - Card List: 카드 목록
    func fetchCardList(errorHandler: @escaping (_ error: Error?) -> Void, completionHandler: @escaping () -> Void) {
        NetworkAPI.shared.cardList { [weak self] (cardListResponse, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler()
                errorHandler(error)
                return
            }
            guard let cardListResponse = cardListResponse else {
                self.setCardList(to: [])
                self.emitCardList()
                completionHandler()
                errorHandler(NetworkError.nilData)
                return
            }
            let cardList = cardListResponse.data.list
            self.setCardList(to: cardList)
            self.emitCardList()
            self.setCurrentCardID(to: self.cardList[self.currentCardIndex].id)
            self.fetchCardTransaction(errorHandler: errorHandler, completionHandler: completionHandler)
        }
    }
    
    private func emitCardList() {
        Observable.of(cardList)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.cardListSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Card Transaction: 카드 결제 내역
    func fetchCardTransaction(errorHandler: @escaping (_ error: Error?) -> Void, completionHandler: @escaping () -> Void) {
        let card = cardList[currentCardIndex]
        NetworkAPI.shared.cardTransaction(id: card.id, month: month) { [weak self] (cardTransactionListResponse, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler()
                errorHandler(error)
                return
            }
            guard let cardTransactionListResponse = cardTransactionListResponse else {
                self.setCardTransactionList(to: [])
                self.emitCardTransactionList(completionHandler: completionHandler)
                completionHandler()
                errorHandler(NetworkError.nilData)
                return
            }
            let cardTransactionList = cardTransactionListResponse.data.list.sorted { $0.date > $1.date }
            self.setCardTransactionList(to: cardTransactionList)
            self.emitCardTransactionList(completionHandler: completionHandler)
        }
    }
    
    private func emitCardTransactionList(completionHandler: @escaping () -> Void) {
        Observable.of(cardTransactionList)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.cardTransactionListSubject.onNext($0)
                completionHandler()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Delete Card: 카드 삭제
    func deleteCard(errorHandler: @escaping (_ error: Error?) -> Void, completionHandler: @escaping () -> Void) {
        NetworkAPI.shared.deleteCard(id: currentCardID) { [weak self] (cardResponse, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler()
                errorHandler(error)
                return
            }
            guard let _ = cardResponse else {
                completionHandler()
                errorHandler(NetworkError.nilData)
                return
            }
            self.fetchCardList(errorHandler: errorHandler, completionHandler: completionHandler)
        }
    }
    
}

// MARK: - Set Properties
extension MainViewModel {
 
    // MARK: - Card List
    func setCardList(to cardList: [Card]) {
        self.cardList = cardList
        if cardList.count < 10 {
            self.cardList.append(Card(id: Constants.Id.emptyCard, name: ""))
        }
    }
    
    // MARK: - Current Card Index
    func setCurrentCardIndex(to index: Int) {
        self.currentCardIndex = index
    }
    
    // MARK: - Year, Month
    func setSelectedYear(to year: Int) {
        self.selectedYear = year
    }
    
    func setSelectedMonth(to month: Int) {
        self.selectedMonth = month
    }
    
    // MARK: - Card Transaction List
    func setCardTransactionList(to cardTransactionList: [CardTransaction]) {
        self.cardTransactionList = cardTransactionList
    }
    
    // MARK: - Current Card ID
    func setCurrentCardID(to id: String) {
        self.currentCardID = id
    }
    
}
