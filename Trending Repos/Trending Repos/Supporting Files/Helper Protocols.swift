//
//  Helper Protocols.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

protocol IdentifiableCell {
    static func getIdentifier() -> String
}

extension IdentifiableCell {
    static var name: String {
        return String(describing: self)
    }

    static func getIdentifier() -> String {
        return self.name
    }
}
