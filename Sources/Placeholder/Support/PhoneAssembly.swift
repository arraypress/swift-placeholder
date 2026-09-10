//
//  PhoneAssembly.swift
//  Placeholder
//

import Foundation

/// A number from a block, and the check that a number is inside one.
enum PhoneAssembly {

    /// A number from `block`: the lead, then a tail zero-padded to the block's width.
    static func number(from block: PhoneBlock, using generator: inout some RandomNumberGenerator) -> String {
        guard block.width > 0 else { return block.lead }
        let tail = Sampling.int(in: block.range, using: &generator)
        return block.lead + padded(tail, to: block.width)
    }

    /// `value` as digits, left-padded with zeros to `width`.
    static func padded(_ value: Int, to width: Int) -> String {
        let digits = String(value)
        return String(repeating: "0", count: max(0, width - digits.count)) + digits
    }

    /// Whether `number` is one the block could have produced.
    static func contains(_ number: String, in block: PhoneBlock) -> Bool {
        guard number.hasPrefix(block.lead) else { return false }
        let tail = String(number.dropFirst(block.lead.count))
        guard block.width > 0 else { return tail.isEmpty }
        guard tail.count == block.width, tail.allSatisfy(\.isNumber), let value = Int(tail) else { return false }
        return block.range.contains(value)
    }
}
