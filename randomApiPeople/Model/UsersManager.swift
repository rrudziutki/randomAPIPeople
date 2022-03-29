//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

protocol UsersManagerDelegate {
    func updateUsersName(with usersData: [UserModel])
    func didFailed(with error: Error)
}

struct UsersManager {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    
    var delegate: UsersManagerDelegate?
    
    func performRequest() {
        guard let url = URL(string: usersURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                delegate?.didFailed(with: error)
                return
            }
            if let safeData = data {
                if let usersData = parseJSON(safeData) {
                    delegate?.updateUsersName(with: usersData)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> [UserModel]? {
        let decoder = JSONDecoder()
        var arr = [UserModel]()
        do {
            let decodedData = try decoder.decode([UsersData].self, from: data)
            for user in decodedData {
                let id = user.id
                let name = user.name
                let username = user.username
                arr.append(UserModel(id: id, name: name, username: username))
            }
        } catch {
            delegate?.didFailed(with: error)
            return nil
        }
        return arr
    }
}
