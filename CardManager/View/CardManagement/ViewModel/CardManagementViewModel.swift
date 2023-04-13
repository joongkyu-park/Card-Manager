//
//  CardManagementViewModel.swift
//  CardManager
//
//  Created by Apple on 2023/02/22.
//

import Foundation

import RxSwift

final class CardManagementViewModel {
    
    // MARK: - Observables
    private(set) var cardListSubject = PublishSubject<[Card]>()
    private(set) var cardTransactionListSubject = PublishSubject<[CardTransaction]>()
    
    // MARK: - Properties
    private var cardID: String?
    
    // MARK: - Instances
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(cardID: String?) {
        self.cardID = cardID
    }
    
}

// MARK: - REST API
extension CardManagementViewModel {
    
    // MARK: - Create Card: 카드 등록
    func createCard(name: String, errorHandler: @escaping (_ error: Error?) -> Void, completionHandler: @escaping () -> Void) {
        NetworkAPI.shared.createCard(name: name) { (cardResponse, error) in
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
            completionHandler()
            
        }
    }
    
    // MARK: - Rename Card: 카드 이름 수정
    func renameCard(name: String, errorHandler: @escaping (_ error: Error?) -> Void, completionHandler: @escaping () -> Void) {
        guard let cardID = cardID else { return }
        NetworkAPI.shared.renameCard(id: cardID, name: name) { (cardResponse, error) in
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
            completionHandler()
        }
    }
    
}
