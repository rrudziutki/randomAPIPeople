//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

struct UsersManager {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    
    func performRequest() {
        guard let url = URL(string: usersURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                parseJSON(safeData)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([UsersData].self, from: data)
        } catch {
            print(error)
        }
    }
    
}
