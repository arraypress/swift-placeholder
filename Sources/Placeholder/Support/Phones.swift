//
//  Phones.swift
//  Placeholder
//

import Foundation

extension Placeholder {

    /// A phone number from the range `region`'s regulator reserved for fiction,
    /// formatted the way that country writes numbers.
    ///
    /// Every block is chosen with equal probability, then a number within it.
    /// The blocks and their sources are in ``PhoneRanges``.
    public static func phone(region: Region, using generator: inout some RandomNumberGenerator) -> String {
        let block = Sampling.pick(PhoneRanges.blocks(for: region), using: &generator)
        return PhoneAssembly.number(from: block, using: &generator)
    }

    /// ``phone(region:using:)`` with the system's randomness.
    public static func phone(region: Region) -> String {
        Sampling.withSystemGenerator { phone(region: region, using: &$0) }
    }
}
