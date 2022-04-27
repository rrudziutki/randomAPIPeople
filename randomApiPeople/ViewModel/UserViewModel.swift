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
    var umi: UsersManager?
    
    init(usersManager: UsersManager = UsersManagerImpl()) {
        umi = usersManager
    }
    func getUsers() {
        umi?.fetchUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let successValue):
                    self.users = successValue.map( { return $0 } )
                    self.delegate?.updateUI()
                    
                case .failure(let error):
                    switch error {
                    case .serverError(let errorMessage):
                        self.delegate?.presentAlert(message: errorMessage)
                    case .invalidURL:
                        self.delegate?.presentAlert(message: "Invalid URL")
                    case .noData:
                        self.delegate?.presentAlert(message: "No data send from server")
                    case .decodingError:
                        self.delegate?.presentAlert(message: "Error while decoding data")
                    }
                }
                
            }
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
