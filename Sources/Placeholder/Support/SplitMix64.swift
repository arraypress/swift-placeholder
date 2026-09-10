//
//  SplitMix64.swift
//  Placeholder
//
//  The reference step, written so it can be checked against the paper line by line.
//

import Foundation

/// The SplitMix64 step from Steele, Lea and Flood (2014).
///
/// The state advances by 2⁶⁴/φ each call, which visits every 64-bit value once
/// before repeating; the two multiply-xorshift rounds turn that counter into
/// output that passes the usual statistical batteries. The constants are the
/// published ones, unchanged, so the first output for seed 0 is
/// `0xE220A8397B1DCDAF` here as in every other implementation.
enum SplitMix64 {

    /// Advances `state` and returns the next output.
    static func next(_ state: inout UInt64) -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
