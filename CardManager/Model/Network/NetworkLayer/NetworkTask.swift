//
//  NetworkTask.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

enum NetworkTask {
    
    case requestPlain
    case requestJSONEncodable(body: Encodable)
    
}
