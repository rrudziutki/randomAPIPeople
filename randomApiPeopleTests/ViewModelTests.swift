//
//  randomApiPeopleTests.swift
//  randomApiPeopleTests
//
//  Created by Remik Makuchowski on 13/04/2022.
//

import XCTest
@testable import randomApiPeople

class ViewModelTests: XCTestCase {
    var sut: UserViewModel!
    var session: URLSession!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UserViewModel()
        session = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        session = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_ApiCall() {
        //given
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let promise = expectation(description: "Handler invoked")
        var statusCode: Int?
        var responseError: Error?
        //when
        let task = session.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        task.resume()
        wait(for: [promise], timeout: 5)
        //then
        XCTAssertNil(responseError, "Api Response Error")
        XCTAssertEqual(statusCode, 200)
    }
  
    func test_GetUserFromJson() {
        //given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "UserData", withExtension: "json") else {
            XCTFail("Missing UserData.json file")
            return
        }
        let data = try! Data(contentsOf: url)
        //when
        let userArray: [User]? = sut.parseJSON(data)
        guard let unwrappedUsers = userArray else { return }
        let user = unwrappedUsers[0]
        //then
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Leanne Graham")
        XCTAssertEqual(user.username, "Bret")
        }
    
    func test_handleError() {
        //given
        let statusCode = 404
        //when
        let errorMessage = sut.handleErrorWith(statusCode: statusCode)
        //then
        XCTAssertEqual(errorMessage, "Sorry, this resource is currently unavailable.")
    }
}
