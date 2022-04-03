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
    
    //MARK: - Response Error Handling
    enum ErrorCodes: Int {
        case permanentRedirect = 301
        case temporaryRedirect = 302
        case notFound = 404
        case gone = 410
        case internalServerError = 500
        case serviceUnavailable = 503
    }
    
    func statusCodeErrorHandler() -> String {
        switch ErrorCodes(rawValue: self.statusCode) {
        case .permanentRedirect:
            return "You have to be redirected to another URL"
        case .temporaryRedirect:
            return "You have to be temporary redirected to another URL."
        case .notFound:
                return "Sorry, this resource is currently unavailable."
        case .gone:
            return "Sorry, this resource does not exist."
        case .internalServerError:
            return "Sorry, server problems."
        case .serviceUnavailable:
            return "Service unavailable, please come back later."
        default:
            return "Unknown error"
        }
    }
}
