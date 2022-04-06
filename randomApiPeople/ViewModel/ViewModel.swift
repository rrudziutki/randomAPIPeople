//
//  UsersManager.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

struct UserViewModel {
    let id: Int
    let name: String
    let username: String
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
    }
}
