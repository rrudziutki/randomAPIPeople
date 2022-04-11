//
//  HTTPResponse.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 02/04/2022.
//

import Foundation

extension HTTPURLResponse {
    var isSucces: Bool {
        if self.statusCode == 200 {
            return true
        }
        return false
    }
}
