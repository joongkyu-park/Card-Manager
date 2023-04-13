//
//  CardListResponse.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

struct CardListResponse: Decodable {
    
    let data: CardList
    
}

struct CardList: Decodable {
    
    let list: [Card]
    
}
