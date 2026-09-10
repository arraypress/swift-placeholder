//
//  English.swift
//  Placeholder
//

import Foundation

extension Placeholder {

    /// One plain-English sentence for when Latin looks wrong in a mockup:
    /// capitalised, past tense, a full stop, and nothing worth reading.
    public static func sentence(using generator: inout some RandomNumberGenerator) -> String {
        EnglishAssembly.sentence(using: &generator)
    }

    /// ``sentence(using:)`` with the system's randomness.
    public static func sentence() -> String {
        Sampling.withSystemGenerator { sentence(using: &$0) }
    }

    /// `sentences` plain-English sentences on one line. Zero or fewer gives an empty string.
    public static func paragraph(sentences: Int = 4, using generator: inout some RandomNumberGenerator) -> String {
        EnglishAssembly.paragraph(sentences: sentences, using: &generator)
    }

    /// ``paragraph(sentences:using:)`` with the system's randomness.
    public static func paragraph(sentences: Int = 4) -> String {
        Sampling.withSystemGenerator { paragraph(sentences: sentences, using: &$0) }
    }
}
