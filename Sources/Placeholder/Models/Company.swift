//
//  Company.swift
//  Placeholder
//

import Foundation

/// A company that does not trade, at a domain that cannot receive mail.
public struct Company: Sendable, Hashable, Codable {

    /// The trading name, two words that sound like a business.
    public let name: String

    /// The legal form: Ltd, LLC, GmbH, Inc. and the like.
    public let suffix: String

    /// One of the RFC 2606 example domains.
    public let emailDomain: String

    /// A company from its parts.
    public init(name: String, suffix: String, emailDomain: String) {
        self.name = name
        self.suffix = suffix
        self.emailDomain = emailDomain
    }
}
