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
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let safeData = data {
                            if let unwrapedData = parseJSON(safeData) {
                                delegate?.updateUsersName(with: unwrapedData)
                            }
                        }
                    } else {
                        // TODO - StatusCodes error handling
                        delegate?.didFailed(with: error!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> [UserModel]? {
        let decoder = JSONDecoder()
        var users = [UserModel]()
        do {
            let decodedData = try decoder.decode([UsersData].self, from: data)
            for user in decodedData {
                let id = user.id
                let name = user.name
                let username = user.username
                users.append(UserModel(id: id, name: name, username: username))
            }
        } catch {
            delegate?.didFailed(with: error)
            return nil
        }
        return users
    }
}
