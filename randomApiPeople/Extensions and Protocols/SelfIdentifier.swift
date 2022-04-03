//
//  SelfIdentifier.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 03/04/2022.
//

import Foundation

protocol SelfIdentifier {
    static var selfIdentifier: String { get }
}

extension SelfIdentifier {
    static var selfIdentifier: String {
        String(describing: self)
    }
}
