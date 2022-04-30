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

}
