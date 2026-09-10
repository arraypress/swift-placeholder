//
//  PeopleTests.swift
//  PlaceholderTests
//
//  A person is plausible in the name and safe in the contact details. The
//  safety is checked over hundreds of seeds, because one lucky draw proves
//  nothing about a range.
//

import XCTest
@testable import Placeholder

final class PeopleTests: XCTestCase {

    private let reservedDomains = ["example.com", "example.org", "example.net", "example.edu"]

    func testAPersonHasEveryField() {
        var generator = seeded()
        let person = Placeholder.person(using: &generator)
        XCTAssertFalse(person.givenName.isEmpty)
        XCTAssertFalse(person.familyName.isEmpty)
        XCTAssertTrue(person.email.contains("@"))
        XCTAssertFalse(person.phone.isEmpty)
        XCTAssertEqual(person.fullName, "\(person.givenName) \(person.familyName)")
    }

    func testEveryEmailUsesAReservedDomain() {
        for seed in 0..<500 {
            var generator = seeded(UInt64(seed))
            let person = Placeholder.person(using: &generator)
            let domain = String(person.email.split(separator: "@").last!)
            XCTAssertTrue(reservedDomains.contains(domain), person.email)
            let another = Placeholder.email(for: person, using: &generator)
            XCTAssertTrue(reservedDomains.contains(String(another.split(separator: "@").last!)), another)
        }
    }

    func testEveryLocalPartIsPlainASCIIWithNoLeadingTrailingOrDoubledDot() {
        for seed in 0..<500 {
            var generator = seeded(UInt64(seed))
            let email = Placeholder.person(using: &generator).email
            let local = String(email.split(separator: "@").first!)
            XCTAssertTrue(matches("[a-z0-9]+(\\.[a-z0-9]+)*", local), email)
            XCTAssertEqual(email.filter { $0 == "@" }.count, 1)
            XCTAssertFalse(email.contains(" "))
        }
    }

    func testDiacriticsSurviveInTheNameAndFoldInTheEmail() {
        let person = Person(givenName: "Zoë", familyName: "Müller", email: "", phone: "")
        XCTAssertEqual(person.fullName, "Zoë Müller")
        XCTAssertEqual(person.initials, "ZM")
        var generator = seeded()
        let email = Placeholder.email(givenName: "Zoë", familyName: "Müller", using: &generator)
        XCTAssertTrue(email.hasPrefix("zoe.muller"), email)
    }

    func testApostrophesSpacesAndHyphensLeaveTheLocalPart() {
        XCTAssertEqual(EmailAssembly.localPart(givenName: "Seán", familyName: "O'Brien", suffix: ""), "sean.obrien")
        XCTAssertEqual(EmailAssembly.localPart(givenName: "Jean-Luc", familyName: "van der Berg", suffix: "7"), "jeanluc.vanderberg7")
    }

    func testAnEmptyNameStillMakesAValidAddress() {
        XCTAssertEqual(EmailAssembly.localPart(givenName: "", familyName: "", suffix: ""), "user")
        XCTAssertEqual(EmailAssembly.localPart(givenName: "Ana", familyName: "", suffix: ""), "ana")
    }

    func testTheNameListsKeepTheirDiacritics() {
        XCTAssertTrue(NameLists.givenNames.contains("Zoë"))
        XCTAssertTrue(NameLists.familyNames.contains("Müller"))
        XCTAssertGreaterThan(NameLists.givenNames.count, 150)
        XCTAssertGreaterThan(NameLists.familyNames.count, 150)
    }

    func testInitialsComeFromBothNames() {
        XCTAssertEqual(NameAssembly.initials(given: "maria", family: "garcía"), "MG")
        XCTAssertEqual(NameAssembly.initials(given: "", family: "Solo"), "S")
        XCTAssertEqual(NameAssembly.fullName(given: "", family: "Solo"), "Solo")
    }

    func testAPersonsPhoneComesFromTheirRegion() {
        for region in Region.allCases {
            var generator = seeded(3)
            let person = Placeholder.person(region: region, using: &generator)
            let blocks = PhoneRanges.blocks(for: region)
            XCTAssertTrue(blocks.contains { PhoneAssembly.contains(person.phone, in: $0) }, "\(region): \(person.phone)")
        }
    }

    func testAPersonRoundTripsThroughCodable() throws {
        var generator = seeded()
        let person = Placeholder.person(using: &generator)
        XCTAssertEqual(try roundTrip(person), person)
    }

    func testTheSameSeedGivesTheSamePerson() {
        var a = seeded(23), b = seeded(23)
        XCTAssertEqual(Placeholder.person(using: &a), Placeholder.person(using: &b))
        XCTAssertEqual(Placeholder.email(givenName: "A", familyName: "B", using: &a), Placeholder.email(givenName: "A", familyName: "B", using: &b))
    }

    func testTheUnseededOverloadsHaveTheSameShape() {
        let person = Placeholder.person()
        XCTAssertTrue(person.email.contains("@example."))
        XCTAssertTrue(Placeholder.email(for: person).contains("@example."))
        XCTAssertTrue(Placeholder.email(givenName: "Ada", familyName: "Lovelace").hasPrefix("ada.lovelace"))
        XCTAssertTrue(Placeholder.person(region: .ireland).phone.hasPrefix("0"))
    }
}
