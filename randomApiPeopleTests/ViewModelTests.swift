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
        let session = URLSessionMock()
        let mockDelegate = UserViewModelDelegateMock()

        override func setUpWithError() throws {
            try super.setUpWithError()
            sut = UserViewModel(usersManager: UsersManagerImpl(session: session))
            sut.delegate = mockDelegate
        }

        override func tearDownWithError() throws {
            sut = nil
            try super.tearDownWithError()
        }
        
        func test_getUsers_happyPath() {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: "UserData", withExtension: "json") else {
                XCTFail("No JSON file")
                return
            }
            let data = try! Data(contentsOf: url)
            session.data = data
            session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            sut.getUsers()
            XCTAssertFalse(mockDelegate.isPresentAlertCalled)
            XCTAssertTrue(mockDelegate.isUpdateUICalled)
            XCTAssertEqual([User(id: 1, name: "Leanne Graham", username: "Bret")], sut.users)
        }
        
        func test_error404() {
            session.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
            sut.getUsers()
            XCTAssertTrue(mockDelegate.isPresentAlertCalled)
            XCTAssertFalse(mockDelegate.isUpdateUICalled)
            XCTAssertEqual(mockDelegate.alertMessage, "Sorry, this resource cannot be found.")
        }
            
           
}
