//
//  HTTPMethod.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")
    static let patch = HTTPMethod(rawValue: "PATCH")
    static let delete = HTTPMethod(rawValue: "DELETE")
    
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}
