//
//  CardResponse.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

struct CardResponse: Decodable {
    
    let data: Card

}

struct Card: Decodable {
    
    let id, name: String
    
}
