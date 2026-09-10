//
//  Sampling.swift
//  Placeholder
//
//  Every random choice in the package goes through here, so determinism has one door.
//

import Foundation

/// Uniform picks from a generator, done the same way on every toolchain.
///
/// The standard library's `randomElement(using:)` is deterministic for a given
/// generator, but how it maps 64 bits onto a range is an implementation detail
/// that has changed between Swift releases. A fixture that must match across
/// machines cannot depend on that, so the mapping lives here: a modulo, whose
/// bias for the list sizes in this package (hundreds against 2⁶⁴) is nil.
enum Sampling {

    /// A uniform index below `count`.
    static func index(below count: Int, using generator: inout some RandomNumberGenerator) -> Int {
        precondition(count > 0, "nothing to sample from")
        return Int(generator.next() % UInt64(count))
    }

    /// A uniform value from a closed range.
    static func int(in range: ClosedRange<Int>, using generator: inout some RandomNumberGenerator) -> Int {
        range.lowerBound + index(below: range.count, using: &generator)
    }

    /// One element, uniformly.
    static func pick<Element>(_ items: [Element], using generator: inout some RandomNumberGenerator) -> Element {
        items[index(below: items.count, using: &generator)]
    }

    /// True with the given probability, from the top 53 bits of one draw.
    static func chance(_ probability: Double, using generator: inout some RandomNumberGenerator) -> Bool {
        Double(generator.next() >> 11) / Double(1 << 53) < probability
    }

    /// Runs `body` with the system generator, for the overloads that take no seed.
    static func withSystemGenerator<Result>(_ body: (inout SystemRandomNumberGenerator) -> Result) -> Result {
        var generator = SystemRandomNumberGenerator()
        return body(&generator)
    }
}
