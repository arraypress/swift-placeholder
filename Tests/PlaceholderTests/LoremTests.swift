//
//  LoremTests.swift
//  PlaceholderTests
//
//  Counts are exact or the function is wrong. Every test names the count it
//  asked for and checks that count, plus the shape rules: one space between
//  words, a capital at the front of a sentence, a full stop at the end.
//

import XCTest
@testable import Placeholder

final class LoremTests: XCTestCase {

    // MARK: Words

    func testSevenWordsAreSevenWords() {
        var generator = seeded()
        let text = Lorem.words(7, using: &generator)
        XCTAssertEqual(text.split(separator: " ").count, 7)
        XCTAssertFalse(text.contains("  "))
        XCTAssertFalse(text.contains("."))
    }

    func testOneWordIsOneWordAndZeroIsNothing() {
        var generator = seeded()
        XCTAssertEqual(Lorem.words(1, using: &generator).split(separator: " ").count, 1)
        XCTAssertEqual(Lorem.words(0, using: &generator), "")
        XCTAssertEqual(Lorem.words(-4, using: &generator), "")
    }

    func testEveryWordIsInTheVocabulary() {
        var generator = seeded(11)
        let corpus = Set(LoremCorpus.words)
        for word in Lorem.words(500, using: &generator).split(separator: " ") {
            XCTAssertTrue(corpus.contains(String(word)), "\(word) is not in the corpus")
        }
    }

    func testTheSameWordNeverAppearsTwiceRunning() {
        var generator = seeded(12)
        let words = Lorem.words(2000, using: &generator).split(separator: " ")
        for pair in zip(words, words.dropFirst()) {
            XCTAssertNotEqual(pair.0, pair.1)
        }
    }

    func testTenThousandWordsComeBackQuickly() {
        var generator = seeded()
        let started = Date()
        let text = Lorem.words(10_000, using: &generator)
        XCTAssertEqual(text.split(separator: " ").count, 10_000)
        XCTAssertLessThan(Date().timeIntervalSince(started), 1)
    }

    // MARK: Sentences

    func testFourSentencesEndInFourFullStops() {
        var generator = seeded()
        let line = Lorem.sentences(4, using: &generator)
        XCTAssertEqual(line.filter { $0 == "." }.count, 4)
        XCTAssertEqual(sentences(in: line).count, 4)
    }

    func testOneSentenceAndZeroSentences() {
        var generator = seeded()
        XCTAssertEqual(sentences(in: Lorem.sentences(1, using: &generator)).count, 1)
        XCTAssertEqual(Lorem.sentences(0, using: &generator), "")
        XCTAssertEqual(Lorem.sentences(-1, using: &generator), "")
    }

    func testEverySentenceIsCapitalisedAndEndsWithOneFullStop() {
        var generator = seeded(13)
        for sentence in sentences(in: Lorem.sentences(200, using: &generator)) {
            XCTAssertTrue(sentence.first!.isUppercase, sentence)
            XCTAssertTrue(sentence.hasSuffix("."), sentence)
            XCTAssertEqual(sentence.filter { $0 == "." }.count, 1, sentence)
            XCTAssertFalse(sentence.contains("  "), sentence)
            XCTAssertFalse(sentence.contains(" ,"), sentence)
        }
    }

    func testSentenceLengthWithMinEqualToMaxGivesExactlyThatManyWords() {
        var generator = seeded(14)
        let options = Lorem.Options(sentenceLength: 5...5)
        for sentence in sentences(in: Lorem.sentences(50, options: options, using: &generator)) {
            XCTAssertEqual(sentence.split(separator: " ").count, 5, sentence)
        }
    }

    func testABoundBelowOneIsReadAsOne() {
        // A closed range cannot be inverted — `5...2` traps at construction — so
        // the only degenerate case is a bound below one, which clamps.
        var generator = seeded(15)
        let options = Lorem.Options(sentenceLength: 0...0, paragraphLength: -3...(-1))
        let paragraphs = Lorem.paragraphs(3, options: options, using: &generator).components(separatedBy: "\n\n")
        XCTAssertEqual(paragraphs.count, 3)
        for paragraph in paragraphs {
            XCTAssertEqual(sentences(in: paragraph).count, 1, "paragraph length -3...-1 clamps to one sentence")
            XCTAssertEqual(paragraph.split(separator: " ").count, 1, "sentence length 0...0 clamps to one word")
        }
        XCTAssertEqual(LoremAssembly.clamped(0...0), 1...1)
        XCTAssertEqual(LoremAssembly.clamped(-5...3), 1...3)
    }

    // MARK: Paragraphs

    func testThreeParagraphsAreSeparatedByExactlyOneBlankLine() {
        var generator = seeded()
        let text = Lorem.paragraphs(3, using: &generator)
        XCTAssertEqual(text.components(separatedBy: "\n\n").count, 3)
        XCTAssertFalse(text.contains("\n\n\n"))
        XCTAssertFalse(text.hasPrefix("\n"))
        XCTAssertFalse(text.hasSuffix("\n"))
    }

    func testOneParagraphHasNoBlankLineAndZeroIsNothing() {
        var generator = seeded()
        XCTAssertFalse(Lorem.paragraphs(1, using: &generator).contains("\n"))
        XCTAssertEqual(Lorem.paragraphs(0, using: &generator), "")
        XCTAssertEqual(Lorem.paragraphs(-2, using: &generator), "")
    }

    func testParagraphLengthWithMinEqualToMaxGivesExactlyThatManySentences() {
        var generator = seeded(16)
        let options = Lorem.Options(paragraphLength: 2...2)
        for paragraph in Lorem.paragraphs(20, options: options, using: &generator).components(separatedBy: "\n\n") {
            XCTAssertEqual(sentences(in: paragraph).count, 2, paragraph)
        }
    }

    func testPlainParagraphsNeverCarryTheClassicOpening() {
        var generator = seeded(17)
        XCTAssertFalse(Lorem.paragraphs(5, using: &generator).contains(Lorem.classicOpening))
    }

    // MARK: Text

    func testTheClassicOpeningLeadsExactlyOnce() {
        var generator = seeded()
        let text = Lorem.text(paragraphs: 4, using: &generator)
        XCTAssertTrue(text.hasPrefix(Lorem.classicOpening + ". "))
        XCTAssertEqual(text.components(separatedBy: Lorem.classicOpening).count - 1, 1, "once, in the first paragraph only")
        XCTAssertEqual(text.components(separatedBy: "\n\n").count, 4)
    }

    func testTheClassicOpeningIsAbsentWhenNotAsked() {
        var generator = seeded()
        XCTAssertFalse(Lorem.text(paragraphs: 4, startingWithClassic: false, using: &generator).contains(Lorem.classicOpening))
    }

    func testTextWithOneParagraphIsTheClassicSentenceThenProse() {
        var generator = seeded()
        let text = Lorem.text(paragraphs: 1, using: &generator)
        XCTAssertFalse(text.contains("\n"))
        XCTAssertTrue(text.hasPrefix("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "))
        XCTAssertGreaterThan(sentences(in: text).count, 1)
    }

    func testTextWithZeroParagraphsIsEmptyEvenWithTheClassicOpening() {
        var generator = seeded()
        XCTAssertEqual(Lorem.text(paragraphs: 0, startingWithClassic: true, using: &generator), "")
    }

    // MARK: Characters

    func testOneHundredAndTwentyCharactersIsExactlyOneHundredAndTwenty() {
        var generator = seeded()
        XCTAssertEqual(Lorem.characters(120, using: &generator).count, 120)
    }

    func testTheSmallestCountsAreExactToo() {
        var generator = seeded()
        XCTAssertEqual(Lorem.characters(0, using: &generator), "")
        XCTAssertEqual(Lorem.characters(-1, using: &generator), "")
        let one = Lorem.characters(1, using: &generator)
        XCTAssertEqual(one.count, 1)
        XCTAssertTrue(one.first!.isLetter)
        let two = Lorem.characters(2, using: &generator)
        XCTAssertEqual(two.count, 2)
        XCTAssertTrue(two.allSatisfy(\.isLetter))
    }

    func testACountShorterThanTheClassicOpeningIsStillExact() {
        var generator = seeded()
        let text = Lorem.characters(10, using: &generator)
        XCTAssertEqual(text.count, 10)
        XCTAssertLessThan(text.count, Lorem.classicOpening.count)
    }

    func testEveryLengthUpToThreeHundredIsExactAndEndsOnAWholeWord() throws {
        let corpus = Set(LoremCorpus.words)
        for seed in [18, 19, 20] as [UInt64] {
            var generator = seeded(seed)
            for count in 1...300 {
                let text = Lorem.characters(count, using: &generator)
                XCTAssertEqual(text.count, count, "asked for \(count)")
                XCTAssertNotEqual(text.last, " ", "trailing space at \(count)")
                XCTAssertFalse(text.contains("  "), "double space at \(count)")
                XCTAssertNotEqual(text.last, ",", "dangling comma at \(count)")
                let lastWord = try XCTUnwrap(text.split(separator: " ").last).filter(\.isLetter).lowercased()
                XCTAssertTrue(corpus.contains(lastWord), "\(lastWord) is a fragment, at \(count)")
            }
        }
    }

    func testALongPassageIsExactAndEveryWordInItIsWhole() {
        var generator = seeded(19)
        let corpus = Set(LoremCorpus.words)
        let text = Lorem.characters(999, using: &generator)
        XCTAssertEqual(text.count, 999)
        for word in text.split(separator: " ") {
            XCTAssertTrue(corpus.contains(word.filter(\.isLetter).lowercased()), "\(word)")
        }
    }

    func testLengtheningTheLastWordKeepsItsPunctuation() {
        var generator = seeded(30)
        let longer = LoremAssembly.lengthenLastWord(of: "Lorem ipsum amet,", using: &generator)
        XCTAssertEqual(longer.count, "Lorem ipsum amet,".count + 1)
        XCTAssertTrue(longer.hasSuffix(","))
        XCTAssertTrue(longer.hasPrefix("Lorem ipsum "))
        let capital = LoremAssembly.lengthenLastWord(of: "Amet.", using: &generator)
        XCTAssertEqual(capital.count, 6)
        XCTAssertTrue(capital.first!.isUppercase)
        XCTAssertTrue(capital.hasSuffix("."))
        // The longest word cannot grow, so a shorter word and "a" stand in.
        let longest = LoremAssembly.lengthenLastWord(of: "Sit reprehenderit.", using: &generator)
        XCTAssertEqual(longest.count, "Sit reprehenderit.".count + 1)
        XCTAssertTrue(longest.hasSuffix(" a."))
    }

    func testAFittedWordHasTheLengthAskedAndTheCaseAsked() {
        var generator = seeded(31)
        for length in 1...13 {
            let lower = LoremAssembly.fitted(length: length, capitalised: false, using: &generator)
            XCTAssertEqual(lower.count, length)
            XCTAssertTrue(lower.first!.isLowercase)
            let upper = LoremAssembly.fitted(length: length, capitalised: true, using: &generator)
            XCTAssertEqual(upper.count, length)
            XCTAssertTrue(upper.first!.isUppercase)
        }
    }

    func testTheCorpusHasAWordOfEveryLengthUpToItsLongest() {
        // The guarantee behind exact length: a fragment is always shorter than
        // the word it came from, so a replacement of that length must exist.
        for length in 1...LoremCorpus.longestWordLength {
            XCTAssertNotNil(LoremCorpus.wordsByLength[length], "no word of length \(length)")
        }
        XCTAssertEqual(LoremCorpus.longestWordLength, 13)
    }

    // MARK: Markup

    func testMarkdownIsTheTextWithABlankLineBetweenParagraphs() {
        var a = seeded(), b = seeded()
        XCTAssertEqual(Lorem.markdown(paragraphs: 3, using: &a), Lorem.text(paragraphs: 3, using: &b))
    }

    func testHTMLWrapsEachParagraphInOneParagraphElement() {
        var generator = seeded()
        let html = Lorem.html(paragraphs: 3, using: &generator)
        let lines = html.components(separatedBy: "\n")
        XCTAssertEqual(lines.count, 3)
        for line in lines {
            XCTAssertTrue(line.hasPrefix("<p>"), line)
            XCTAssertTrue(line.hasSuffix("</p>"), line)
        }
        XCTAssertEqual(html.components(separatedBy: "<p>").count - 1, 3)
    }

    func testNothingInTheOutputEverNeedsEscaping() {
        var generator = seeded(20)
        let text = Lorem.text(paragraphs: 20, using: &generator)
        for forbidden in ["&", "<", ">", "\"", "'"] {
            XCTAssertFalse(text.contains(forbidden))
        }
    }

    func testHTMLAndMarkdownOfZeroParagraphsAreEmpty() {
        var generator = seeded()
        XCTAssertEqual(Lorem.html(paragraphs: 0, using: &generator), "")
        XCTAssertEqual(Lorem.markdown(paragraphs: 0, using: &generator), "")
    }

    // MARK: Options

    func testTheStandardOptionsAreTheDefaultsAndRoundTrip() throws {
        XCTAssertEqual(Lorem.Options.standard, Lorem.Options())
        XCTAssertEqual(Lorem.Options.standard.sentenceLength, 6...14)
        XCTAssertEqual(Lorem.Options.standard.paragraphLength, 4...7)
        let custom = Lorem.Options(sentenceLength: 3...4, paragraphLength: 1...2)
        XCTAssertEqual(try roundTrip(custom), custom)
    }

    // MARK: Determinism and the unseeded overloads

    func testTheSameSeedGivesTheSameTextForEveryGenerator() {
        var a = seeded(21), b = seeded(21)
        XCTAssertEqual(Lorem.words(30, using: &a), Lorem.words(30, using: &b))
        XCTAssertEqual(Lorem.sentences(3, using: &a), Lorem.sentences(3, using: &b))
        XCTAssertEqual(Lorem.paragraphs(2, using: &a), Lorem.paragraphs(2, using: &b))
        XCTAssertEqual(Lorem.characters(77, using: &a), Lorem.characters(77, using: &b))
        XCTAssertEqual(Lorem.text(using: &a), Lorem.text(using: &b))
        XCTAssertEqual(Lorem.html(using: &a), Lorem.html(using: &b))
    }

    func testDifferentSeedsGiveDifferentText() {
        var a = seeded(1), b = seeded(2)
        XCTAssertNotEqual(Lorem.words(20, using: &a), Lorem.words(20, using: &b))
    }

    func testTheUnseededOverloadsHaveTheSameShape() {
        XCTAssertEqual(Lorem.words(5).split(separator: " ").count, 5)
        XCTAssertEqual(sentences(in: Lorem.sentences(2)).count, 2)
        XCTAssertEqual(Lorem.paragraphs(2).components(separatedBy: "\n\n").count, 2)
        XCTAssertEqual(Lorem.characters(64).count, 64)
        XCTAssertTrue(Lorem.text().hasPrefix(Lorem.classicOpening))
        XCTAssertEqual(Lorem.markdown(paragraphs: 2).components(separatedBy: "\n\n").count, 2)
        XCTAssertEqual(Lorem.html(paragraphs: 2).components(separatedBy: "\n").count, 2)
    }
}
