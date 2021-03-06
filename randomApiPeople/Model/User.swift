//
//  UsersData.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 28/03/2022.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let username: String
}

