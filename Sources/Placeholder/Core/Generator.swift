//
//  Generator.swift
//  Placeholder
//
//  A seed in, the same sequence out — on every run and every platform.
//

import Foundation

extension Placeholder {

    /// A seeded source of randomness, so a fixture is the same on every run.
    ///
    /// SplitMix64, from Steele, Lea and Flood, *Fast Splittable Pseudorandom
    /// Number Generators* (OOPSLA 2014) — the generator behind Java's
    /// `SplittableRandom` and the one most others use to seed themselves.
    /// Chosen for what a placeholder needs: a 64-bit seed in, a full-period
    /// sequence out, in three lines a reader can check against the reference.
    /// It is not for cryptography; `SystemRandomNumberGenerator` is.
    ///
    /// Two generators with the same seed, asked the same questions in the same
    /// order, give the same answers. Nothing in this package reads the clock or
    /// any other state, so that promise holds for every value it makes.
    public struct Generator: RandomNumberGenerator, Sendable, Hashable {

        /// The state SplitMix64 advances by its golden-ratio constant each draw.
        private var state: UInt64

        /// Starts the sequence at `seed`. Any value is fine, including zero.
        public init(seed: UInt64) {
            state = seed
        }

        /// The next 64 bits of the sequence.
        public mutating func next() -> UInt64 {
            SplitMix64.next(&state)
        }
    }
}
