//
//  LoremAssembly.swift
//  Placeholder
//
//  Words into sentences, sentences into paragraphs, and text cut to an exact length on a whole word.
//

import Foundation

/// The pure text assembly behind ``Lorem``.
///
/// Two invariants every function keeps: words are separated by exactly one
/// space, and punctuation is attached to the word before it. Between them they
/// make "no double spaces" and "ends on a whole word" true by construction
/// rather than by a final clean-up pass.
enum LoremAssembly {

    /// `count` words from the vocabulary, never the same word twice running.
    static func words(_ count: Int, using generator: inout some RandomNumberGenerator) -> [String] {
        guard count > 0 else { return [] }
        var result: [String] = []
        result.reserveCapacity(count)
        var previous = ""
        for _ in 0..<count {
            var word = Sampling.pick(LoremCorpus.words, using: &generator)
            if word == previous {
                word = Sampling.pick(LoremCorpus.words, using: &generator)
            }
            result.append(word)
            previous = word
        }
        return result
    }

    /// One sentence of `wordCount` words: capitalised, a comma somewhere in the
    /// longer ones, a full stop at the end.
    static func sentence(wordCount: Int, using generator: inout some RandomNumberGenerator) -> String {
        var parts = words(max(1, wordCount), using: &generator)
        if parts.count >= 8, Sampling.chance(0.6, using: &generator) {
            let at = Sampling.int(in: 3...(parts.count - 4), using: &generator)
            parts[at] += ","
        }
        return capitalised(parts.joined(separator: " ")) + "."
    }

    /// `count` sentences whose lengths are drawn from `options`.
    static func sentences(_ count: Int, options: Lorem.Options, using generator: inout some RandomNumberGenerator) -> [String] {
        guard count > 0 else { return [] }
        let lengths = clamped(options.sentenceLength)
        var result: [String] = []
        result.reserveCapacity(count)
        for _ in 0..<count {
            result.append(sentence(wordCount: Sampling.int(in: lengths, using: &generator), using: &generator))
        }
        return result
    }

    /// One paragraph: a run of sentences joined by single spaces.
    static func paragraph(options: Lorem.Options, using generator: inout some RandomNumberGenerator) -> String {
        let count = Sampling.int(in: clamped(options.paragraphLength), using: &generator)
        return sentences(count, options: options, using: &generator).joined(separator: " ")
    }

    /// `count` paragraphs; the first opens with the classic sentence when asked.
    static func paragraphs(_ count: Int, startingWithClassic: Bool, options: Lorem.Options, using generator: inout some RandomNumberGenerator) -> [String] {
        guard count > 0 else { return [] }
        var result: [String] = []
        result.reserveCapacity(count)
        for _ in 0..<count {
            result.append(paragraph(options: options, using: &generator))
        }
        if startingWithClassic {
            result[0] = Lorem.classicOpening + ". " + result[0]
        }
        return result
    }

    /// Exactly `count` characters, ending on a whole word.
    ///
    /// Sentences are generated past the length and walked token by token —
    /// a token is a word with whatever punctuation follows it — for as long as
    /// the next one still fits. What is left is a gap of known size, and each
    /// size has one exact fix:
    ///
    /// - **No gap:** done.
    /// - **One character after a letter:** a full stop closes the sentence.
    /// - **One character after punctuation:** the last word is swapped for one
    ///   a letter longer, keeping its punctuation.
    /// - **Two or more:** a space and a word of exactly the remaining length.
    ///
    /// In every case a comma left at the very end becomes a full stop.
    ///
    /// The last two need a word of a given length to exist, which
    /// ``LoremCorpus`` guarantees for every length up to its longest — and a
    /// gap is never longer than the token that failed to fit.
    static func characters(_ count: Int, options: Lorem.Options, using generator: inout some RandomNumberGenerator) -> String {
        guard count > 0 else { return "" }
        let lengths = clamped(options.sentenceLength)
        var text = ""
        while text.count < count + LoremCorpus.longestWordLength + 2 {
            let next = sentence(wordCount: Sampling.int(in: lengths, using: &generator), using: &generator)
            text += text.isEmpty ? next : " " + next
        }

        var out = ""
        for token in text.split(separator: " ").map(String.init) {
            let candidate = out.isEmpty ? token : out + " " + token
            guard candidate.count <= count else { break }
            out = candidate
        }

        let gap = count - out.count
        if out.isEmpty {
            // Not even the first word fits: the whole text is one word of the length asked.
            out = fitted(length: gap, capitalised: true, using: &generator)
        } else if gap == 1, out.last!.isLetter {
            out.append(".")
        } else if gap == 1 {
            out = lengthenLastWord(of: out, using: &generator)
        } else if gap > 1 {
            out += " " + fitted(length: gap - 1, capitalised: out.hasSuffix("."), using: &generator)
        }
        // Whatever the case, text does not end on a comma.
        if out.hasSuffix(",") {
            out.removeLast()
            out.append(".")
        }
        return out
    }

    /// A vocabulary word of exactly `length` letters, capitalised on request.
    ///
    /// The fallback — the front of the longest word — is unreachable while the
    /// corpus has a word of every length up to its longest, which a test pins.
    static func fitted(length: Int, capitalised: Bool, using generator: inout some RandomNumberGenerator) -> String {
        let longest = LoremCorpus.words.max(by: { $0.count < $1.count }) ?? "lorem"
        let word = LoremCorpus.word(ofLength: length, using: &generator) ?? String(longest.prefix(length))
        return capitalised ? self.capitalised(word) : word
    }

    /// `text` with its final word one letter longer, punctuation kept.
    ///
    /// When the final word is already the longest in the vocabulary the extra
    /// letter comes from a shorter word and a one-letter word after it, which
    /// grows the text by the same one character.
    static func lengthenLastWord(of text: String, using generator: inout some RandomNumberGenerator) -> String {
        var tokens = text.split(separator: " ").map(String.init)
        guard let last = tokens.popLast() else { return text }
        let punctuation = last.last.map { $0.isLetter ? "" : String($0) } ?? ""
        let word = String(last.dropLast(punctuation.count))
        let wasCapitalised = word.first?.isUppercase ?? false
        let replacement: String
        if word.count + 1 <= LoremCorpus.longestWordLength {
            replacement = fitted(length: word.count + 1, capitalised: wasCapitalised, using: &generator)
        } else {
            replacement = fitted(length: word.count - 1, capitalised: wasCapitalised, using: &generator) + " a"
        }
        tokens.append(replacement + punctuation)
        return tokens.joined(separator: " ")
    }

    /// The first letter uppercased, the rest untouched.
    static func capitalised(_ text: String) -> String {
        text.prefix(1).uppercased() + text.dropFirst()
    }

    /// A range with nothing below one in it; a sentence of zero words is not a sentence.
    static func clamped(_ range: ClosedRange<Int>) -> ClosedRange<Int> {
        max(1, range.lowerBound)...max(1, range.upperBound)
    }

    /// Paragraphs as Markdown: one blank line between them.
    static func markdown(_ paragraphs: [String]) -> String {
        paragraphs.joined(separator: "\n\n")
    }

    /// Paragraphs as HTML: one `<p>` each, one per line. Nothing in the
    /// vocabulary needs escaping, so none is done.
    static func html(_ paragraphs: [String]) -> String {
        paragraphs.map { "<p>\($0)</p>" }.joined(separator: "\n")
    }
}
