//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
    func presentAlert(message: String, title: String)
    func updateUI()
}

extension UserViewModelDelegate {
    func presentAlert(message: String, title: String = "Something went wrong") {
        presentAlert(message: message, title: title)
    }
}

class UserViewModel {
    var users = [User]()
    weak var delegate: UserViewModelDelegate?
    private var usersManager: UsersManager?
    
    init(usersManager: UsersManager = UsersManagerImpl()) {
        self.usersManager = usersManager
    }
    
    func getUsers() {
        usersManager?.fetchUsers { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let successValue):
                    self.users = successValue.map( { return $0 } )
                    self.delegate?.updateUI()
                    
                case .failure(let error):
                    self.delegate?.presentAlert(message: self.getErrorMessage(from: error))
                }
        }
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
    
    private func getErrorMessage(from error: MyError) -> String {
        switch MyError(rawValue: error.rawValue) {
        case .parseDataError:
            return "Error while parsing data."
        case .noResponse:
            return "No response from the server."
        case .noData:
            return "No data received from the server."
        case .invalidURL:
            return "Wrong URL."
        case .permanentRedirect:
            return "You have to be redirected to another URL."
        case .temporaryRedirect:
            return "You have to be temporary redirected to another URL."
        case .notFound:
            return "Sorry, this resource cannot be found."
        case .gone:
            return "Sorry, this resource does not exist."
        case .internalServerError:
            return "Sorry, server problems."
        case .serviceUnavailable:
            return "Service unavailable, please come back later."
        case .unknown:
            return "Unknown error"
        default:
            return "Something went wrong"
        }
    }
    
}
