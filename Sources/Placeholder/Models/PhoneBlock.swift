//
//  PhoneBlock.swift
//  Placeholder
//

import Foundation

/// One reserved run of numbers: a fixed lead and a zero-padded tail.
///
/// `(212) 555-01` with a two-digit tail from 0 to 99 is NANPA's block in one
/// area code; `0491 570 006` with no tail is one of ACMA's listed mobiles.
struct PhoneBlock: Sendable, Hashable {

    /// The digits (and formatting) every number in the block shares.
    let lead: String

    /// How many digits the tail is padded to; zero for a single listed number.
    let width: Int

    /// The tail values the regulator reserved.
    let range: ClosedRange<Int>
}
