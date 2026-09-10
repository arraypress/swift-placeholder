//
//  Addresses.swift
//  Placeholder
//

import Foundation

extension Placeholder {

    /// A street address in `region`, in a town that exists only in fiction.
    ///
    /// What is guaranteed and what is not:
    ///
    /// - **Cannot be real:** the town (from television and literature — see
    ///   ``AddressLists``) and, for every region but Australia, the postcode
    ///   (see ``Postcodes`` for the range or shape and why it is safe).
    /// - **Plausible only:** the street — a Maple Street exists somewhere — and
    ///   the region, which is a real state, province or county so the address
    ///   reads correctly. Australian postcodes are plausible only, because
    ///   Australia has reserved none.
    public static func address(region: Region, using generator: inout some RandomNumberGenerator) -> Address {
        let number = Sampling.int(in: 1...999, using: &generator)
        let street = Sampling.pick(AddressLists.streetNames, using: &generator)
        let type = Sampling.pick(AddressLists.streetTypes(for: region), using: &generator)
        let city = Sampling.pick(AddressLists.towns(for: region), using: &generator)
        let area = Sampling.pick(AddressLists.regions(for: region), using: &generator)
        let postcode = Postcodes.postcode(for: region, using: &generator)
        return Address(
            line1: "\(number) \(street) \(type)",
            city: city,
            region: area,
            postcode: postcode,
            country: region.countryName
        )
    }

    /// ``address(region:using:)`` with the system's randomness.
    public static func address(region: Region) -> Address {
        Sampling.withSystemGenerator { address(region: region, using: &$0) }
    }
}
