//
//  UsersManagerMock.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 30/04/2022.
//

import Foundation
@testable import randomApiPeople

//class UsersManagerSuccesMock: UsersManager {
//    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void) {
//        let bundle = Bundle(for: type(of: self))
//        guard let url = bundle.url(forResource: "UserData", withExtension: "json") else {
//            return
//        }
//        let data = try! Data(contentsOf: url)
//        completionHandler(.success(unwrappedData))
//    }
//}

class UsersManagerFailParsingError: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void) {
        completionHandler(.failure(.parseDataError))
    }
}

class UsersManagerFail404Mock: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void) {
        completionHandler(.failure(MyError(rawValue: 404)!))
    }
}

class UsersManagerFailInvalidUrlMock: UsersManager {
    func fetchUsers(completionHandler: @escaping (Result<[User], MyError>) -> Void) {
        completionHandler(.failure(.invalidURL))
    }
}


