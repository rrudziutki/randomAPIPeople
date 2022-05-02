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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_Fail404Case() {
        let mockDelegate = MockDelegate()
        sut = UserViewModel(usersManager: UsersManagerFail404Mock())
        sut.delegate = mockDelegate
        sut.getUsers()
        DispatchQueue.main.async {
            XCTAssertTrue(mockDelegate.isPresentAlertCalled)
            XCTAssertFalse(mockDelegate.isUpdateUICalled)
            XCTAssertEqual(mockDelegate.alertMessage, "Sorry, this resource cannot be found.")
        }
    }

    func test_FailInvalidURL() {
        let mockDelegate = MockDelegate()
        sut = UserViewModel(usersManager: UsersManagerFailInvalidUrlMock())
        sut.delegate = mockDelegate
        sut.getUsers()
        DispatchQueue.main.async {
            XCTAssertTrue(mockDelegate.isPresentAlertCalled)
            XCTAssertFalse(mockDelegate.isUpdateUICalled)
            XCTAssertEqual(mockDelegate.alertMessage, "Wrong URL")
        }
    }
    
//    func test_Succes() {
//        let mockDelegate = MockDelegate()
//        sut = UserViewModel(usersManager: UsersManagerSuccesMock())
//        sut.delegate = mockDelegate
//        sut.getUsers()
//        DispatchQueue.main.async {
//            XCTAssertEqual(self.sut.users[0], User(id: 1, name: "Leanne Graham", username: "Bret"))
//        }
//    }
    
    func test_FailWhileParsingData() {
        sut = UserViewModel(usersManager: UsersManagerFail404Mock())
        let mockDelegate = MockDelegate()
        sut.delegate = mockDelegate
        sut.getUsers()
        DispatchQueue.main.async {
            XCTAssertFalse(mockDelegate.isPresentAlertCalled)
            XCTAssertTrue(mockDelegate.isUpdateUICalled)
            XCTAssertEqual(mockDelegate.alertMessage, "Error while parsing data")
        }
    }
    
}
