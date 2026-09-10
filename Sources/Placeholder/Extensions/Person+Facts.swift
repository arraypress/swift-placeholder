//
//  Person+Facts.swift
//  Placeholder
//

import Foundation

extension Person {

    /// Given name and family name with a space between.
    public var fullName: String {
        NameAssembly.fullName(given: givenName, family: familyName)
    }

    /// The first letter of each name, uppercased.
    public var initials: String {
        NameAssembly.initials(given: givenName, family: familyName)
    }
}
