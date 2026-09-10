//
//  SequenceTests.swift
//  PlaceholderTests
//
//  The promise is not "each generator is deterministic" but "a whole fixture
//  is": every generator called in turn from one seed, twice, must agree.
//

import XCTest
@testable import Placeholder

final class SequenceTests: XCTestCase {

    /// Every public generator, once each, in a fixed order.
    private func fixture(seed: UInt64) -> [String] {
        var generator = seeded(seed)
        var result: [String] = []
        result.append(Lorem.words(12, using: &generator))
        result.append(Lorem.sentences(2, using: &generator))
        result.append(Lorem.paragraphs(2, using: &generator))
        result.append(Lorem.characters(90, using: &generator))
        result.append(Lorem.text(paragraphs: 2, using: &generator))
        result.append(Lorem.markdown(paragraphs: 1, using: &generator))
        result.append(Lorem.html(paragraphs: 1, using: &generator))
        for region in Region.allCases {
            let person = Placeholder.person(region: region, using: &generator)
            result.append(person.fullName)
            result.append(person.email)
            result.append(person.phone)
            result.append(Placeholder.email(for: person, using: &generator))
            result.append(Placeholder.phone(region: region, using: &generator))
            result.append(Placeholder.address(region: region, using: &generator).formatted)
        }
        result.append(Placeholder.email(givenName: "Ada", familyName: "Lovelace", using: &generator))
        result.append(Placeholder.company(using: &generator).legalName)
        result.append(Placeholder.sentence(using: &generator))
        result.append(Placeholder.paragraph(sentences: 3, using: &generator))
        return result
    }

    func testAWholeFixtureReproducesFromOneSeed() {
        XCTAssertEqual(fixture(seed: 99), fixture(seed: 99))
    }

    func testAWholeFixtureChangesWithTheSeed() {
        XCTAssertNotEqual(fixture(seed: 99), fixture(seed: 100))
    }

    func testNothingInAFixtureHasADoubleSpace() {
        for line in fixture(seed: 101) {
            XCTAssertFalse(line.contains("  "), line)
        }
    }
}
