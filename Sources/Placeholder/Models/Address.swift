//
//  Address.swift
//  Placeholder
//

import Foundation

/// A street address in a town that exists only in fiction.
///
/// Which parts are guaranteed fictional and which are merely plausible is
/// spelled out on ``Placeholder/address(region:using:)``: the town and the
/// postcode cannot be real; the street name and the region can be.
public struct Address: Sendable, Hashable, Codable {

    /// House number and street.
    public let line1: String

    /// A town from television or literature.
    public let city: String

    /// The state, province or county — a real one, so the address reads right.
    public let region: String

    /// A postcode from a range or shape no real address can have.
    public let postcode: String

    /// The country's name.
    public let country: String

    /// An address from its parts; nothing is validated, so a real address fits too.
    public init(line1: String, city: String, region: String, postcode: String, country: String) {
        self.line1 = line1
        self.city = city
        self.region = region
        self.postcode = postcode
        self.country = country
    }
}
