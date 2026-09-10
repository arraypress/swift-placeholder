//
//  AddressFormatting.swift
//  Placeholder
//

import Foundation

/// An address as the lines on an envelope.
enum AddressFormatting {

    /// Street, town, then region and postcode on one line, then the country.
    static func lines(_ address: Address) -> [String] {
        [
            address.line1,
            address.city,
            [address.region, address.postcode].filter { !$0.isEmpty }.joined(separator: " "),
            address.country,
        ].filter { !$0.isEmpty }
    }
}
