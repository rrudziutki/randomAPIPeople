//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 26/04/2022.
//

import Foundation

protocol UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void, defaultURL: String)
}

extension UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void, defaultURL: String = "https://jsonplaceholder.typicode.com/users") {
        fetchUsers(completionHandler: completionHandler, defaultURL: defaultURL)
    }
}

struct UsersManagerImpl: UsersManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void, defaultURL: String) {
        guard let url = URL(string: defaultURL) else {
            completionHandler(.failure(.invalidURL))
            return
        }
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
                guard let unwrappedData = parseJSON(safeData) else {
                    completionHandler(.failure(.parseDataError))
                    return
                }
                completionHandler(.success(unwrappedData))
                return
            } else {
                completionHandler(.failure(MyError(rawValue: httpResponse.statusCode) ?? .unknown))
            }
        }
        task.resume()
    }

    private func parseJSON(_ data: Data) -> [User]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([User].self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}

//MARK: - Errors Enum
enum MyError: Int, Error {
    case parseDataError
    case noResponse
    case noData
    case invalidURL
    case permanentRedirect = 301
    case temporaryRedirect = 302
    case notFound = 404
    case gone = 410
    case internalServerError = 500
    case serviceUnavailable = 503
    case unknown
}
