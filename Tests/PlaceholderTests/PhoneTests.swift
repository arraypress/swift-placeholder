//
//  PhoneTests.swift
//  PlaceholderTests
//
//  Every number must sit inside a block a regulator reserved, and every block
//  must actually be reachable — a range nothing ever lands in is a lie in the
//  README.
//

import XCTest
@testable import Placeholder

final class PhoneTests: XCTestCase {

    func testEveryNumberFallsInsideAReservedBlockOfItsRegion() {
        for region in Region.allCases {
            let blocks = PhoneRanges.blocks(for: region)
            for seed in 0..<500 {
                var generator = seeded(UInt64(seed))
                let number = Placeholder.phone(region: region, using: &generator)
                XCTAssertTrue(blocks.contains { PhoneAssembly.contains(number, in: $0) }, "\(region): \(number)")
            }
        }
    }

    func testEveryReservedBlockOfEveryRegionIsHitAtLeastOnce() {
        for region in Region.allCases {
            let blocks = PhoneRanges.blocks(for: region)
            var hits = Array(repeating: 0, count: blocks.count)
            var generator = seeded(UInt64(region.hashValue & 0xFFFF))
            for _ in 0..<(blocks.count * 200) {
                let number = Placeholder.phone(region: region, using: &generator)
                if let index = blocks.firstIndex(where: { PhoneAssembly.contains(number, in: $0) }) {
                    hits[index] += 1
                }
            }
            for (block, count) in zip(blocks, hits) {
                XCTAssertGreaterThan(count, 0, "\(region): \(block.lead) never drawn")
            }
        }
    }

    func testDigitCountsMatchEachCountrysNumberingPlan() {
        let expected: [Region: Int] = [.unitedStates: 10, .canada: 10, .unitedKingdom: 11, .ireland: 10, .australia: 10]
        for region in Region.allCases {
            for seed in 0..<200 {
                var generator = seeded(UInt64(seed))
                let number = Placeholder.phone(region: region, using: &generator)
                XCTAssertEqual(digits(number).count, expected[region], "\(region): \(number)")
            }
        }
    }

    func testAmericanAndCanadianNumbersUseTheFictional555Block() {
        for region in [Region.unitedStates, .canada] {
            for seed in 0..<200 {
                var generator = seeded(UInt64(seed))
                XCTAssertTrue(matches("\\(\\d{3}\\) 555-01\\d{2}", Placeholder.phone(region: region, using: &generator)))
            }
        }
    }

    func testBritishNumbersComeOnlyFromOfcomsDramaRanges() {
        let leads = PhoneRanges.unitedKingdom.map(\.lead)
        XCTAssertTrue(leads.contains("07700 900"))
        XCTAssertTrue(leads.contains("020 7946 0"))
        XCTAssertTrue(leads.contains("01632 960"))
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let number = Placeholder.phone(region: .unitedKingdom, using: &generator)
            XCTAssertTrue(leads.contains { number.hasPrefix($0) }, number)
            XCTAssertEqual(number.count, leads.first { number.hasPrefix($0) }!.count + 3)
        }
    }

    func testIrishNumbersUseComRegsRanges() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let number = Placeholder.phone(region: .ireland, using: &generator)
            XCTAssertTrue(matches("020 910 \\d{4}|089 011 0\\d{3}", number), number)
        }
    }

    func testAustralianMobilesComeOnlyFromACMAsList() {
        let listed = Set(PhoneRanges.australia.filter { $0.width == 0 }.map(\.lead))
        XCTAssertEqual(listed.count, 41, "thirty mobiles and eleven 1800/1300 numbers")
        for seed in 0..<1000 {
            var generator = seeded(UInt64(seed))
            let number = Placeholder.phone(region: .australia, using: &generator)
            if number.hasPrefix("04") || number.hasPrefix("18") || number.hasPrefix("13") {
                XCTAssertTrue(listed.contains(number), number)
            } else {
                XCTAssertTrue(matches("\\(0[2378]\\) (5550|7010) \\d{4}", number), number)
            }
        }
    }

    func testABlockRejectsNumbersOutsideIt() {
        let block = PhoneBlock(lead: "(212) 555-01", width: 2, range: 0...99)
        XCTAssertTrue(PhoneAssembly.contains("(212) 555-0142", in: block))
        XCTAssertFalse(PhoneAssembly.contains("(212) 555-0242", in: block), "wrong exchange")
        XCTAssertFalse(PhoneAssembly.contains("(212) 555-014", in: block), "short tail")
        XCTAssertFalse(PhoneAssembly.contains("(212) 555-01ab", in: block), "letters")
        let single = PhoneBlock(lead: "0491 570 006", width: 0, range: 0...0)
        XCTAssertTrue(PhoneAssembly.contains("0491 570 006", in: single))
        XCTAssertFalse(PhoneAssembly.contains("0491 570 0067", in: single))
    }

    func testPaddingKeepsLeadingZeros() {
        XCTAssertEqual(PhoneAssembly.padded(7, to: 3), "007")
        XCTAssertEqual(PhoneAssembly.padded(1234, to: 3), "1234")
        XCTAssertEqual(PhoneAssembly.padded(0, to: 0), "0")
    }

    func testRegionCoversEveryCaseWithANameAndRoundTrips() throws {
        XCTAssertEqual(Region.allCases.count, 5)
        for region in Region.allCases {
            XCTAssertFalse(region.countryName.isEmpty)
            XCTAssertFalse(PhoneRanges.blocks(for: region).isEmpty)
            XCTAssertEqual(try roundTrip(region), region)
        }
        XCTAssertEqual(Region.unitedKingdom.countryName, "United Kingdom")
    }

    func testTheSameSeedGivesTheSameNumberAndTheUnseededOverloadIsInRange() {
        var a = seeded(24), b = seeded(24)
        XCTAssertEqual(Placeholder.phone(region: .australia, using: &a), Placeholder.phone(region: .australia, using: &b))
        let number = Placeholder.phone(region: .unitedStates)
        XCTAssertTrue(PhoneRanges.unitedStates.contains { PhoneAssembly.contains(number, in: $0) })
    }
}
