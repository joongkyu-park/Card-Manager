//
//  NetworkService.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

enum NetworkService {
    
    case createCard(name: String)
    case renameCard(id: String, name: String)
    case deleteCard(id: String)
    case cardList
    case cardTransaction(id: String, month: String)
    
}

extension NetworkService: TargetType {
    
    var baseURLPath: String {
        return Constants.URL.base
    }
    
    var path: String {
        switch self {
        case .createCard:
            return "/card"
        case .renameCard:
            return "/card"
        case .deleteCard:
            return "/card"
        case .cardList:
            return "/card/list"
        case .cardTransaction:
            return "/card/transaction"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createCard:
            return .post
        case .renameCard:
            return .patch
        case .deleteCard:
            return .delete
        case .cardList, .cardTransaction:
            return .get
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .createCard(let name):
            let cardRequestItem = CardRequestItem(name: name)
            return .requestJSONEncodable(body: cardRequestItem)
        case .renameCard(let id, let name):
            let cardRenameRequestItem = CardRenameRequestItem(id: id, name: name)
            return .requestJSONEncodable(body: cardRenameRequestItem)
        case .cardList, .cardTransaction, .deleteCard:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createCard, .renameCard, .cardList:
            return nil
        case .deleteCard(let id):
            return ["id": id]
        case .cardTransaction(let id, let month):
            return ["id": id,
                    "month": month]
        }
    }
    
}
