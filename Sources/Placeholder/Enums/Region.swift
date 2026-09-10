//
//  Region.swift
//  Placeholder
//

import Foundation

/// The countries whose regulators have set numbers aside for fiction.
///
/// A phone number is only safe inside a range somebody reserved, and those
/// ranges are national: NANPA's 555-01XX, Ofcom's drama blocks, ComReg's
/// 020 910, ACMA's list. Addresses follow the same regions so a person's
/// number and street agree on which country they are in.
public enum Region: String, CaseIterable, Sendable, Hashable, Codable {

    /// NANPA's 555-0100 to 555-0199, in an American area code.
    case unitedStates

    /// The same NANPA block, in a Canadian area code.
    case canada

    /// Ofcom's drama ranges — geographic, mobile and freephone.
    case unitedKingdom

    /// ComReg's 020 910 0000–9999 and 089 011 0000–0999.
    case ireland

    /// ACMA's 5550 and 7010 landline blocks and its listed mobiles.
    case australia

    /// The country's name as it appears on the last line of an address.
    public var countryName: String {
        switch self {
        case .unitedStates:  "United States"
        case .canada:        "Canada"
        case .unitedKingdom: "United Kingdom"
        case .ireland:       "Ireland"
        case .australia:     "Australia"
        }
    }
}
