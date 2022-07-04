//
//  UsersManagerTests.swift
//  randomApiPeopleTests
//
//  Created by Remigiusz Makuchowski on 04/07/2022.
//

import XCTest
@testable import randomApiPeople

class UsersManagerTests: XCTestCase {
    var sut: UsersManager!
    let session = URLSessionMock()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UsersManagerImpl(session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_success() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "UserData", withExtension: "json") else {
            XCTFail("No JSON file")
            return
        }
        let data = try! Data(contentsOf: url)
        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.fetchUsers(completionHandler: { result in
           switch result {
           case .success(let user):
               XCTAssert(user[0] == User(id: 1, name: "Leanne Graham", username: "Bret"))
           case .failure(_):
               XCTFail("Happy path - this should not be called")
           }
        })
    }

    func test_invalidURL() {
        sut.fetchUsers(completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("Wrong URL - this should not be called")
            case .failure(let error):
                XCTAssert(error == MyError.invalidURL)
            }
        }, defaultURL: "wrong url")
    }
    
    func test_noResponse() {
         sut.fetchUsers(completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("No response - this should not be called")
            case .failure(let error):
                XCTAssert(error == MyError.noResponse)
            }
        })
    }
    
    func test_noData() {
        session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.fetchUsers(completionHandler: { result in
           switch result {
           case .success(_):
               XCTFail("No data - this should not be called")
           case .failure(let error):
               XCTAssert(error == MyError.noData)
           }
        })
    }
    
    func test_parseJSONError() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "CorruptedJSONData", withExtension: "json") else {
            XCTFail("No JSON file")
            return
        }
        let data = try! Data(contentsOf: url)
        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut.fetchUsers(completionHandler: { result in
           switch result {
           case .success(_):
               XCTFail("Corrupted json file - this should not be called")
           case .failure(let error):
               XCTAssert(error == MyError.parseDataError)
           }
        })
    }
    
    func test_unknownError() {
        session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 696, httpVersion: nil, headerFields: nil)
        sut.fetchUsers(completionHandler: { result in
           switch result {
           case .success(_):
               XCTFail("Corrupted json file - this should not be called")
           case .failure(let error):
               XCTAssert(error == MyError.unknown)
           }
        })
    }
}
