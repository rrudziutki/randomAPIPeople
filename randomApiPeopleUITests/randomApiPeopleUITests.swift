//
//  randomApiPeopleUITests.swift
//  randomApiPeopleUITests
//
//  Created by Remik Makuchowski on 14/04/2022.
//

import XCTest

class randomApiPeopleUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testExample() throws {
        let collectionViewsQuery = app.collectionViews
        let usersButton = app.navigationBars["Bret"].buttons["Users"]
        collectionViewsQuery.staticTexts["Bret"].tap()
        XCTAssertTrue(app.tables.staticTexts["User ID: 1"].exists)
        XCTAssertFalse(!app.tables.staticTexts["User ID: 1"].exists)
        usersButton.tap()
        app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element.swipeUp()
        collectionViewsQuery.staticTexts["Moriah.Stanton"].tap()
        XCTAssertTrue(app.tables.staticTexts["User ID: 10"].exists)
        XCTAssertFalse(!app.tables.staticTexts["User ID: 10"].exists)
    }

    
}
