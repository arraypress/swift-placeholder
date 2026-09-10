//
//  LoremGeneration.swift
//  Placeholder
//
//  The public surface of Lorem: every function once with a generator and once without.
//

import Foundation

extension Lorem {

    // MARK: Words

    /// `count` lowercase words separated by single spaces, with no punctuation.
    /// Zero or fewer gives an empty string.
    public static func words(_ count: Int, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.words(count, using: &generator).joined(separator: " ")
    }

    /// ``words(_:using:)`` with the system's randomness.
    public static func words(_ count: Int) -> String {
        Sampling.withSystemGenerator { words(count, using: &$0) }
    }

    // MARK: Sentences

    /// `count` sentences on one line, each capitalised and ending in a full stop.
    /// Zero or fewer gives an empty string.
    public static func sentences(_ count: Int, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.sentences(count, options: options, using: &generator).joined(separator: " ")
    }

    /// ``sentences(_:options:using:)`` with the system's randomness.
    public static func sentences(_ count: Int, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { sentences(count, options: options, using: &$0) }
    }

    // MARK: Paragraphs

    /// `count` paragraphs separated by one blank line, without the classic opening.
    /// Zero or fewer gives an empty string.
    public static func paragraphs(_ count: Int, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.markdown(LoremAssembly.paragraphs(count, startingWithClassic: false, options: options, using: &generator))
    }

    /// ``paragraphs(_:options:using:)`` with the system's randomness.
    public static func paragraphs(_ count: Int, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { paragraphs(count, options: options, using: &$0) }
    }

    // MARK: Text

    /// Body copy: `paragraphs` paragraphs, the first opening with
    /// ``classicOpening`` unless told otherwise, separated by one blank line.
    public static func text(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.markdown(LoremAssembly.paragraphs(paragraphs, startingWithClassic: startingWithClassic, options: options, using: &generator))
    }

    /// ``text(paragraphs:startingWithClassic:options:using:)`` with the system's randomness.
    public static func text(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { text(paragraphs: paragraphs, startingWithClassic: startingWithClassic, options: options, using: &$0) }
    }

    // MARK: Characters

    /// Exactly `count` characters, ending on a whole word — never one short,
    /// never a word cut in half, never a trailing space. Zero or fewer gives an
    /// empty string. See ``LoremAssembly`` for how the last word is fitted.
    public static func characters(_ count: Int, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.characters(count, options: options, using: &generator)
    }

    /// ``characters(_:options:using:)`` with the system's randomness.
    public static func characters(_ count: Int, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { characters(count, options: options, using: &$0) }
    }

    // MARK: Markup

    /// ``text(paragraphs:startingWithClassic:options:using:)`` as Markdown —
    /// which, for plain paragraphs, is the same text with a blank line between them.
    public static func markdown(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.markdown(LoremAssembly.paragraphs(paragraphs, startingWithClassic: startingWithClassic, options: options, using: &generator))
    }

    /// ``markdown(paragraphs:startingWithClassic:options:using:)`` with the system's randomness.
    public static func markdown(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { markdown(paragraphs: paragraphs, startingWithClassic: startingWithClassic, options: options, using: &$0) }
    }

    /// The same paragraphs as HTML: one `<p>` element per paragraph, one per line.
    public static func html(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard, using generator: inout some RandomNumberGenerator) -> String {
        LoremAssembly.html(LoremAssembly.paragraphs(paragraphs, startingWithClassic: startingWithClassic, options: options, using: &generator))
    }

    /// ``html(paragraphs:startingWithClassic:options:using:)`` with the system's randomness.
    public static func html(paragraphs: Int = 3, startingWithClassic: Bool = true, options: Options = .standard) -> String {
        Sampling.withSystemGenerator { html(paragraphs: paragraphs, startingWithClassic: startingWithClassic, options: options, using: &$0) }
    }
}
