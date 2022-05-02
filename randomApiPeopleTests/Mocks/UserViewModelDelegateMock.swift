//
//  UsersManagerDelegateMock.swift
//  randomApiPeopleTests
//
//  Created by Remigiusz Makuchowski on 02/05/2022.
//

import Foundation
@testable import randomApiPeople

class UserViewModelDelegateMock: UserViewModelDelegate {
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
