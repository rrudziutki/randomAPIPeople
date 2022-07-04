//
//  UsersManagerMock.swift
//  randomApiPeople
//
//  Created by Remigiusz Makuchowski on 30/04/2022.
//

import Foundation
@testable import randomApiPeople

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


