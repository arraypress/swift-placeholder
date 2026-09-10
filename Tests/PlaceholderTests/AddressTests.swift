//
//  AddressTests.swift
//  PlaceholderTests
//
//  The town and the postcode carry the guarantee; the tests check each region's
//  postcode against the rule that makes it safe, and the town against the list
//  of places that only exist on screen.
//

import XCTest
@testable import Placeholder

final class AddressTests: XCTestCase {

    func testEveryFieldIsFilledForEveryRegion() {
        for region in Region.allCases {
            for seed in 0..<200 {
                var generator = seeded(UInt64(seed))
                let address = Placeholder.address(region: region, using: &generator)
                XCTAssertFalse(address.line1.isEmpty)
                XCTAssertFalse(address.city.isEmpty)
                XCTAssertFalse(address.region.isEmpty)
                XCTAssertFalse(address.postcode.isEmpty)
                XCTAssertEqual(address.country, region.countryName)
                XCTAssertTrue(matches("\\d{1,3} [A-Z][a-z]+ [A-Z][a-z]+", address.line1), address.line1)
                XCTAssertTrue(AddressLists.towns(for: region).contains(address.city), address.city)
                XCTAssertTrue(AddressLists.regions(for: region).contains(address.region), address.region)
            }
        }
    }

    func testAmericanZipCodesSitBelowTheLowestAssignedOne() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let postcode = Placeholder.address(region: .unitedStates, using: &generator).postcode
            XCTAssertEqual(postcode.count, 5, postcode)
            XCTAssertTrue((100...499).contains(Int(postcode)!), "\(postcode) is not below 00501")
        }
    }

    func testBritishPostcodesStartWithALetterRoyalMailNeverUses() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let postcode = Placeholder.address(region: .unitedKingdom, using: &generator).postcode
            XCTAssertTrue(matches("XX\\d{1,2} \\d[ABDEFGHJLNPQRSTUWXYZ]{2}", postcode), postcode)
        }
    }

    func testCanadianPostalCodesStartWithAnUnassignedLetter() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let postcode = Placeholder.address(region: .canada, using: &generator).postcode
            XCTAssertTrue(matches("Z\\d[ABCEGHJKLMNPRSTVWXYZ] \\d[ABCEGHJKLMNPRSTVWXYZ]\\d", postcode), postcode)
        }
    }

    func testIrishEircodesUseAnUnassignedRoutingKey() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let postcode = Placeholder.address(region: .ireland, using: &generator).postcode
            XCTAssertTrue(matches("Z99 [ACDEFHKNPRTVWXY0-9]{4}", postcode), postcode)
        }
    }

    func testAustralianPostcodesAreFourDigitsAndOnlyPlausible() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let postcode = Placeholder.address(region: .australia, using: &generator).postcode
            XCTAssertTrue(matches("08\\d{2}", postcode), postcode)
        }
    }

    func testEveryTownAndStreetTypeListIsPopulated() {
        for region in Region.allCases {
            XCTAssertGreaterThanOrEqual(AddressLists.towns(for: region).count, 5, "\(region)")
            XCTAssertGreaterThanOrEqual(AddressLists.streetTypes(for: region).count, 5, "\(region)")
            XCTAssertGreaterThanOrEqual(AddressLists.regions(for: region).count, 5, "\(region)")
        }
    }

    func testFormattingPutsOneLinePerPart() {
        let address = Address(line1: "12 Maple Street", city: "Ambridge", region: "Borsetshire", postcode: "XX1 2AB", country: "United Kingdom")
        XCTAssertEqual(address.formatted, "12 Maple Street\nAmbridge\nBorsetshire XX1 2AB\nUnited Kingdom")
        let sparse = Address(line1: "1 Elm Road", city: "Walford", region: "", postcode: "", country: "United Kingdom")
        XCTAssertEqual(sparse.formatted, "1 Elm Road\nWalford\nUnited Kingdom")
    }

    func testAnAddressRoundTripsThroughCodable() throws {
        var generator = seeded()
        let address = Placeholder.address(region: .canada, using: &generator)
        XCTAssertEqual(try roundTrip(address), address)
    }

    func testTheSameSeedGivesTheSameAddressAndTheUnseededOverloadHasTheShape() {
        var a = seeded(25), b = seeded(25)
        XCTAssertEqual(Placeholder.address(region: .ireland, using: &a), Placeholder.address(region: .ireland, using: &b))
        XCTAssertEqual(Placeholder.address(region: .australia).country, "Australia")
    }
}
