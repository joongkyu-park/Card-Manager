//
//  NetworkAPI.swift
//  CardManager
//
//  Created by Apple on 2023/02/18.
//

import Foundation
import TestSession

struct NetworkAPI {
    
    // MARK: - Singleton
    static let shared = NetworkAPI()
    private init() { }
    
    // MARK: - Instances
    private let provider = NetworkProvider<NetworkService>()
    
}

// MARK: - REST API
extension NetworkAPI {
    
    func createCard(name: String, completionHandler: @escaping (CardResponse?, Error?) -> Void) {
        do {
            let request = try provider.request(.createCard(name: name))
            let task = URLSession.testSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, NetworkError.nilData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, NetworkError.invalidServerResponse)
                    return
                }
                do {
                    let result = try self.judgeStatus(by: response.statusCode, data, type: CardResponse.self)
                    completionHandler(result, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }

    }
    
    func renameCard(id: String, name: String, completionHandler: @escaping (CardResponse?, Error?) -> Void) {
        do {
            let request = try provider.request(.renameCard(id: id, name: name))
            let task = URLSession.testSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, NetworkError.nilData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, NetworkError.invalidServerResponse)
                    return
                }
                do {
                    let result = try self.judgeStatus(by: response.statusCode, data, type: CardResponse.self)
                    completionHandler(result, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
    func deleteCard(id: String, completionHandler: @escaping (CardListResponse?, Error?) -> Void) {
        do {
            let request = try provider.request(.deleteCard(id: id))
            let task = URLSession.testSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, NetworkError.nilData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, NetworkError.invalidServerResponse)
                    return
                }
                do {
                    let result = try self.judgeStatus(by: response.statusCode, data, type: CardListResponse.self)
                    completionHandler(result, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
    func cardList(completionHandler: @escaping (CardListResponse?, Error?) -> Void) {
        do {
            let request = try provider.request(.cardList)
            let task = URLSession.testSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, NetworkError.nilData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, NetworkError.invalidServerResponse)
                    return
                }
                do {
                    let result = try self.judgeStatus(by: response.statusCode, data, type: CardListResponse.self)
                    completionHandler(result, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
    func cardTransaction(id: String, month:String, completionHandler: @escaping (CardTransactionListResponse?, Error?) -> Void) {
        do {
            let request = try provider.request(.cardTransaction(id: id, month: month))
            let task = URLSession.testSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, NetworkError.nilData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, NetworkError.invalidServerResponse)
                    return
                }
                do {
                    let result = try self.judgeStatus(by: response.statusCode, data, type: CardTransactionListResponse.self)
                    completionHandler(result, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
}

// MARK: - Judge Response
extension NetworkAPI {
    
    private func judgeStatus<T: Decodable>(by statusCode: Int, _ data: Data, type: T.Type) throws -> T {
        switch statusCode {
        case 200:
            return try decodeData(from: data, to: type)
        case 400..<500:
            throw NetworkError.requestError(statusCode)
        case 500:
            throw NetworkError.serverError(statusCode)
        default:
            throw NetworkError.networkFailError(statusCode)
        }
    }
    
    private func decodeData<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodeError(toType: T.self)
        }
        return decodedData
    }
    
}
