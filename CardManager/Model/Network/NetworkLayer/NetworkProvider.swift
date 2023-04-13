//
//  NetworkProvider.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation

struct NetworkProvider<Target: TargetType> {
    
    func request(_ target: Target) throws -> URLRequest {
        
        // MARK: - Path
        let path = target.baseURLPath + target.path
        guard let urlComponents = URLComponents(string: path) else {
            throw NetworkError.invalidURLComponents(path)
        }
        
        // MARK: - URL
        var url: URL?
        let task = target.task
        switch task {
        case .requestPlain, .requestJSONEncodable:
            url = urlComponents.url
        }
        guard let url = url else {
            throw NetworkError.invalidURLString
        }
        
        // MARK: - Ruqest
        var request = URLRequest(url: url)
        switch task {
        case .requestPlain: break
        case .requestJSONEncodable(let body):
            let bodyEncoded = try JSONEncoder().encode(body)
            request.httpBody = bodyEncoded
        }
        
        // MARK: - Header
        request.httpMethod = target.method.rawValue
        if let headerField = target.headers {
            _ = headerField.map { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
}
