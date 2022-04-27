//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 26/04/2022.
//

import Foundation

protocol UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void)
}

struct UsersManagerImpl: UsersManager {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void) {
        guard let url = URL(string: usersURL) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completionHandler(.failure(.serverError(error?.localizedDescription ?? "Unknown error")))
                return
            }
            guard let safeData = data  else {
                completionHandler(.failure(.noData))
                return
            }
            guard let unwrappedData = parseJSON(safeData) else {
                completionHandler(.failure(.decodingError))
                return
            }
            completionHandler(.success(unwrappedData))
            return
        }
        task.resume()
    }
    
 
    func parseJSON(_ data: Data) -> [User]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([User].self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
}

enum MyError: Error {
    case serverError(String)
    case invalidURL
    case noData
    case decodingError
}

