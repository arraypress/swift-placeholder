//
//  Postcodes.swift
//  Placeholder
//
//  Postcodes shaped like the real thing from ranges the real thing never uses.
//

import Foundation

/// A postcode per region, from a range or shape no address can have.
///
/// | Region | What is generated | Why it cannot be real |
/// |---|---|---|
/// | United States | `00100`–`00499` | The lowest assigned ZIP code is 00501 (Holtsville, NY). Unassigned as of writing; the USPS could assign it. |
/// | United Kingdom | `XX` area, e.g. `XX12 3AB` | Royal Mail never uses Q, V or X as the first letter, so no XX postcode can exist. Strict format validators reject it for the same reason. |
/// | Canada | `Z1A 0B1` shape | No postal code starts with Z; the first letter is a province, and Z is not one. |
/// | Ireland | `Z99 XXXX` | Eircode routing keys never begin with Z. |
/// | Australia | four digits, `0800`–`0899` | Australia has no reserved range. These sit in the Northern Territory's block and are merely plausible — an address here **may** collide with a real postcode. |
enum Postcodes {

    /// A postcode for the region.
    static func postcode(for region: Region, using generator: inout some RandomNumberGenerator) -> String {
        switch region {
        case .unitedStates:  unitedStates(using: &generator)
        case .canada:        canada(using: &generator)
        case .unitedKingdom: unitedKingdom(using: &generator)
        case .ireland:       ireland(using: &generator)
        case .australia:     australia(using: &generator)
        }
    }

    /// Five digits from 00100 to 00499, below the first assigned ZIP code.
    static func unitedStates(using generator: inout some RandomNumberGenerator) -> String {
        PhoneAssembly.padded(Sampling.int(in: 100...499, using: &generator), to: 5)
    }

    /// `XX` plus a district and a full inward code, in Royal Mail's letters.
    static func unitedKingdom(using generator: inout some RandomNumberGenerator) -> String {
        let inwardLetters = Array("ABDEFGHJLNPQRSTUWXYZ")
        let district = Sampling.int(in: 1...99, using: &generator)
        let sector = Sampling.int(in: 0...9, using: &generator)
        let unit = String(Sampling.pick(inwardLetters, using: &generator)) + String(Sampling.pick(inwardLetters, using: &generator))
        return "XX\(district) \(sector)\(unit)"
    }

    /// `Z` then the alternating letter–digit shape, in Canada Post's letters.
    static func canada(using generator: inout some RandomNumberGenerator) -> String {
        let letters = Array("ABCEGHJKLMNPRSTVWXYZ")
        func digit() -> String { String(Sampling.int(in: 0...9, using: &generator)) }
        func letter() -> String { String(Sampling.pick(letters, using: &generator)) }
        return "Z" + digit() + letter() + " " + digit() + letter() + digit()
    }

    /// Routing key `Z99` and a four-character unique identifier from the Eircode alphabet.
    static func ireland(using generator: inout some RandomNumberGenerator) -> String {
        let alphabet = Array("ACDEFHKNPRTVWXY0123456789")
        var unique = ""
        for _ in 0..<4 {
            unique.append(Sampling.pick(alphabet, using: &generator))
        }
        return "Z99 " + unique
    }

    /// Four digits between 0800 and 0899 — plausible, not guaranteed unassigned.
    static func australia(using generator: inout some RandomNumberGenerator) -> String {
        PhoneAssembly.padded(Sampling.int(in: 800...899, using: &generator), to: 4)
    }
}
