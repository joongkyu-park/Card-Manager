//
//  NetworkError.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

enum NetworkError: Error {
    
    case decodeError(toType: Decodable.Type)
    case requestError(Int)
    case serverError(Int)
    case networkFailError(Int)
    case invalidURLComponents(String)
    case invalidURLString
    case invalidServerResponse
    case nilData
    
    var description: String {
        switch self {
        case .decodeError(let type):
            return "Decoding error(type: \(type)."
        case .requestError(let statusCode):
            return "Request error(statusCode: \(statusCode)."
        case .serverError(let statusCode):
            return "Server error(statusCode: \(statusCode)."
        case .networkFailError(let statusCode):
            return "Network fail error(statusCode: \(statusCode)."
        case .invalidURLComponents(let path):
            return "Invalid URL Components(path: \(path)."
        case .invalidURLString:
            return "Invalid URL String."
        case .invalidServerResponse:
            return "Invalid server response."
        case .nilData:
            return "Data is nil."
        }
    }
    
}
