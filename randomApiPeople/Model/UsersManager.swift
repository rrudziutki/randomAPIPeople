//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation
import UIKit

protocol UsersManagerDelegate {
    func updateUsersName(with users: [User])
    func presentError(with message: String)
}

struct UsersManager {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    var delegate: UsersManagerDelegate?
    
    func performRequest() {
        guard let url = URL(string: usersURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, _ in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    delegate?.presentError(with: "No response from the server")
                    return
                }
                if httpResponse.isSucces {
                    if let safeData = data {
                        if let unwrapedData = parseJSON(safeData) {
                            delegate?.updateUsersName(with: unwrapedData)
                        }
                    }
                } else {
                    let message = httpResponse.statusCodeErrorHandler()
                    delegate?.presentError(with: message)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> [User]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([User].self, from: data)
            return decodedData
        } catch {
            delegate?.presentError(with: "Error while parsing data")
            return nil
        }
    }
}
