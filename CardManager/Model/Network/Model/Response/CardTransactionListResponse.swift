//
//  CardTransactionListItem.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation


struct CardTransactionListResponse: Decodable {
    
    let data: CardTransactionList
    
}

struct CardTransactionList: Decodable {
    
    let list: [CardTransaction]
    
}

struct CardTransaction: Decodable {
    
    let id: String
    let product: Product
    let type, date: String
    
}

struct Product: Decodable {
    
    let name: String
    let cost: Int
    
}

enum CardTransactionType: String {
    
    case OK
    case CANCEL
    case UNKNOWN
    
    var description: String {
        switch self{
        case .OK:
            return "결제 완료"
        case .CANCEL:
            return "결제 취소"
        case .UNKNOWN:
            return "알 수 없음"
        }
    }
    
}
