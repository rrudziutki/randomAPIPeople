//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

protocol UserViewModelDelegate {
    func presentAlert(message: String, title: String)
    func updateUI()
}

extension UserViewModelDelegate {
    func presentAlert(message: String, title: String = "Something went wrong") {
        presentAlert(message: message, title: title)
    }
}

class UserViewModel {
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    var users = [User]()
    var delegate: UserViewModelDelegate?
    
    func fetchData() {
        guard let url = URL(string: usersURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, _ in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.delegate?.presentAlert(message: "No response from the server")
                    return
                }
                if httpResponse.isSucces {
                    if let safeData = data {
                        if let unwrapedData = self.parseJSON(safeData) {
                            self.users = unwrapedData.map( { return $0 } )
                            self.delegate?.updateUI()
                        }
                    }
                } else {
                    let message = self.handleErrorWith(statusCode: httpResponse.statusCode)
                    self.delegate?.presentAlert(message: message)
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
            delegate?.presentAlert(message: "Error while parsing data")
            return nil
        }
    }
    
    //MARK: - Response Error Handling
    private enum ErrorCodes: Int {
        case permanentRedirect = 301
        case temporaryRedirect = 302
        case notFound = 404
        case gone = 410
        case internalServerError = 500
        case serviceUnavailable = 503
    }
    
    func handleErrorWith(statusCode: Int) -> String {
        switch ErrorCodes(rawValue: statusCode) {
        case .permanentRedirect:
            return "You have to be redirected to another URL"
        case .temporaryRedirect:
            return "You have to be temporary redirected to another URL."
        case .notFound:
                return "Sorry, this resource is currently unavailable."
        case .gone:
            return "Sorry, this resource does not exist."
        case .internalServerError:
            return "Sorry, server problems."
        case .serviceUnavailable:
            return "Service unavailable, please come back later."
        default:
            return "Unknown error"
        }
    }
}
