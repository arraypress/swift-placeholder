//
//  EnglishTests.swift
//  PlaceholderTests
//
//  Filler that reads as English has to obey the two rules a reader notices:
//  "a" before a consonant and "an" before a vowel, and one full stop per sentence.
//

import XCTest
@testable import Placeholder

final class EnglishTests: XCTestCase {

    func testASentenceIsCapitalisedAndEndsWithOneFullStop() {
        for seed in 0..<300 {
            var generator = seeded(UInt64(seed))
            let sentence = Placeholder.sentence(using: &generator)
            XCTAssertTrue(sentence.first!.isUppercase, sentence)
            XCTAssertTrue(sentence.hasSuffix("."), sentence)
            XCTAssertEqual(sentence.filter { $0 == "." }.count, 1, sentence)
            XCTAssertFalse(sentence.contains("  "), sentence)
        }
    }

    func testTheArticleAgreesWithTheWordThatFollowsIt() {
        for seed in 0..<500 {
            var generator = seeded(UInt64(seed))
            let words = Placeholder.sentence(using: &generator).lowercased().split(separator: " ").map(String.init)
            for (article, next) in zip(words, words.dropFirst()) {
                let vowel = "aeiou".contains(next.first!)
                if article == "a" { XCTAssertFalse(vowel, "a \(next)") }
                if article == "an" { XCTAssertTrue(vowel, "an \(next)") }
            }
        }
    }

    func testAParagraphHasTheSentencesAskedFor() {
        var generator = seeded()
        XCTAssertEqual(Placeholder.paragraph(sentences: 4, using: &generator).filter { $0 == "." }.count, 4)
        XCTAssertEqual(sentences(in: Placeholder.paragraph(sentences: 1, using: &generator)).count, 1)
        XCTAssertEqual(Placeholder.paragraph(sentences: 0, using: &generator), "")
        XCTAssertEqual(Placeholder.paragraph(sentences: -2, using: &generator), "")
    }

    func testEveryWordComesFromTheCorpus() {
        let vocabulary = Set((EnglishCorpus.subjects + EnglishCorpus.adjectives + EnglishCorpus.verbs + EnglishCorpus.objects
            + EnglishCorpus.tails.flatMap { $0.split(separator: " ").map(String.init) } + ["the", "a", "an"]).map { $0.lowercased() })
        var generator = seeded(27)
        for word in Placeholder.paragraph(sentences: 200, using: &generator).lowercased().split(separator: " ") {
            XCTAssertTrue(vocabulary.contains(word.filter(\.isLetter)), "\(word)")
        }
    }

    func testTheSameSeedGivesTheSameSentenceAndTheUnseededOverloadsHaveTheShape() {
        var a = seeded(28), b = seeded(28)
        XCTAssertEqual(Placeholder.sentence(using: &a), Placeholder.sentence(using: &b))
        XCTAssertEqual(Placeholder.paragraph(using: &a), Placeholder.paragraph(using: &b))
        XCTAssertTrue(Placeholder.sentence().hasSuffix("."))
        XCTAssertEqual(Placeholder.paragraph(sentences: 3).filter { $0 == "." }.count, 3)
    }
}
