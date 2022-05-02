//
//  UsersManagerMock.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 30/04/2022.
//

import Foundation

//class UsersManagerSuccesMock: UsersManager {
//    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void) {
//        let bundle = Bundle(for: type(of: self))
//        guard let url = bundle.url(forResource: "UserData", withExtension: "json") else {
//            return
//        }
//        let data = try! Data(contentsOf: url)
//        completionHandler(.success(data))
//    }
//}

class UsersManagerFailParsingError: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void) {
        completionHandler(.success(Data()))
    }
}

class UsersManagerFail404Mock: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void) {
        completionHandler(.failure(MyError(rawValue: 404)!))
    }
}

class UsersManagerFailInvalidUrlMock: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<Data, MyError>) -> Void) {
        completionHandler(.failure(.invalidURL))
    }
}

class MockDelegate: UserViewModelDelegate {
    var isUpdateUICalled = false
    var isPresentAlertCalled = false
    var alertMessage = ""
    
    func updateUI() {
        isUpdateUICalled = true
    }
    
    func presentAlert(message: String, title: String) {
        isPresentAlertCalled = true
        alertMessage = message
    }
    
}
