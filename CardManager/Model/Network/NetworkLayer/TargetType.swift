//
//  TargetType.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

protocol TargetType {
    
    var baseURLPath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: NetworkTask { get }
    var headers: [String: String]? { get }
    
}
