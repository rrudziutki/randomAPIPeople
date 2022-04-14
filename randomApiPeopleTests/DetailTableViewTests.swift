//
//  DetailTableViewTests.swift
//  randomApiPeopleTests
//
//  Created by Remik Makuchowski on 14/04/2022.
//

import XCTest
@testable import randomApiPeople

class DetailTableViewTests: XCTestCase {
    var sut: DetailTableViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailTableViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_CreateRows() {
        sut.user = User(id: 1, name: "Adam", username: "AKowalski")
        let cell = UITableViewCell()
        sut.createUsersCell(cell, with: sut.user, attribute: .id)
        XCTAssertEqual(cell.textLabel?.text, "User ID: 1")
    }

}
