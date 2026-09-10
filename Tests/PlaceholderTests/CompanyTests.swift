//
//  CompanyTests.swift
//  PlaceholderTests
//

import XCTest
@testable import Placeholder

final class CompanyTests: XCTestCase {

    func testACompanyHasATwoWordNameAListedSuffixAndAReservedDomain() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let company = Placeholder.company(using: &generator)
            XCTAssertFalse(company.name.isEmpty)
            XCTAssertGreaterThanOrEqual(company.name.split(separator: " ").count, 2, company.name)
            XCTAssertTrue(CompanyLists.suffixes.contains(company.suffix), company.suffix)
            XCTAssertTrue(EmailAssembly.reservedDomains.contains(company.emailDomain), company.emailDomain)
        }
    }

    func testLegalNameAndContactEmailAreBuiltFromTheParts() {
        let company = Company(name: "Northwind Systems", suffix: "Ltd", emailDomain: "example.org")
        XCTAssertEqual(company.legalName, "Northwind Systems Ltd")
        XCTAssertEqual(company.contactEmail, "hello@example.org")
    }

    func testTheSuffixListIsExactlyTheDocumentedOne() {
        XCTAssertEqual(CompanyLists.suffixes, ["Ltd", "LLC", "GmbH", "Inc.", "Pty Ltd", "plc", "S.A.", "AB"])
    }

    func testACompanyRoundTripsThroughCodable() throws {
        var generator = seeded()
        let company = Placeholder.company(using: &generator)
        XCTAssertEqual(try roundTrip(company), company)
    }

    func testTheSameSeedGivesTheSameCompanyAndTheUnseededOverloadHasTheShape() {
        var a = seeded(26), b = seeded(26)
        XCTAssertEqual(Placeholder.company(using: &a), Placeholder.company(using: &b))
        XCTAssertTrue(Placeholder.company().contactEmail.hasPrefix("hello@example."))
    }
}
