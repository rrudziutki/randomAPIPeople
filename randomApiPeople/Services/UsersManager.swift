//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 26/04/2022.
//

import Foundation

protocol UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void)
}

struct UsersManagerImpl: UsersManager {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    
    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void) {
        guard let url = URL(string: usersURL) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.noResponse))
                return
            }
            if httpResponse.isSucces {
                guard let safeData = data else {
                    completionHandler(.failure(.noData))
                    return
                }
                completionHandler(.success(safeData))
                return
            } else {
                completionHandler(.failure(MyError(rawValue: httpResponse.statusCode) ?? .noResponse))
            }
            
        }
        task.resume()
    }
    
    
}

//MARK: - Errors Enum
enum MyError: Int, Error {
    case noResponse
    case noData
    case invalidURL
    case permanentRedirect = 301
    case temporaryRedirect = 302
    case notFound = 404
    case gone = 410
    case internalServerError = 500
    case serviceUnavailable = 503
}
