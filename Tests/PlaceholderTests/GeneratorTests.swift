//
//  GeneratorTests.swift
//  PlaceholderTests
//
//  The seed is the whole promise: same seed, same sequence, checked against the
//  published SplitMix64 output so the implementation is the reference and not
//  merely self-consistent.
//

import XCTest
@testable import Placeholder

final class GeneratorTests: XCTestCase {

    func testSplitMix64MatchesThePublishedFirstOutputForSeedZero() {
        // The reference implementation's first output for seed 0, quoted in
        // the paper's companion code and every port since.
        var generator = seeded(0)
        XCTAssertEqual(generator.next(), 0xE220_A839_7B1D_CDAF)
    }

    func testTheSameSeedGivesTheSameSequence() {
        var a = seeded(42), b = seeded(42)
        for _ in 0..<1000 {
            XCTAssertEqual(a.next(), b.next())
        }
    }

    func testDifferentSeedsDiverge() {
        var a = seeded(1), b = seeded(2)
        XCTAssertNotEqual(a.next(), b.next())
    }

    func testTwoGeneratorsWithTheSameSeedAdvancedDifferentlyDisagree() {
        var a = seeded(7), b = seeded(7)
        _ = a.next()
        XCTAssertNotEqual(a.next(), b.next(), "one draw ahead is a different position in the sequence")
        // And catching up puts them back in step.
        _ = b.next()
        XCTAssertEqual(a.next(), b.next())
    }

    func testGeneratorsAtTheSameSeedAreEqualAndHashAlike() {
        XCTAssertEqual(seeded(5), seeded(5))
        XCTAssertEqual(seeded(5).hashValue, seeded(5).hashValue)
        XCTAssertNotEqual(seeded(5), seeded(6))
    }

    func testSamplingUsesTheWholeRange() {
        var generator = seeded(3)
        var seen = Set<Int>()
        for _ in 0..<2000 {
            seen.insert(Sampling.int(in: 1...6, using: &generator))
        }
        XCTAssertEqual(seen, Set(1...6))
    }

    func testChanceIsNeverTrueAtZeroAndAlwaysTrueAtOne() {
        var generator = seeded(9)
        for _ in 0..<200 {
            XCTAssertFalse(Sampling.chance(0, using: &generator))
            XCTAssertTrue(Sampling.chance(1, using: &generator))
        }
    }
}
