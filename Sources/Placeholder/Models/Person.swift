//
//  Person.swift
//  Placeholder
//

import Foundation

/// A person who does not exist, with contact details that cannot reach anyone.
///
/// The names are common ones from a dozen countries, which makes the person
/// plausible. The email domain and the phone number are what make them safe:
/// both come from ranges reserved so that nobody can hold them.
public struct Person: Sendable, Hashable, Codable {

    /// The first name.
    public let givenName: String

    /// The surname.
    public let familyName: String

    /// An address at one of the RFC 2606 example domains.
    public let email: String

    /// A number from a regulator's fictional range, formatted for its country.
    public let phone: String

    /// A person from their parts; use it to build one by hand for a test.
    public init(givenName: String, familyName: String, email: String, phone: String) {
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.phone = phone
    }
}
