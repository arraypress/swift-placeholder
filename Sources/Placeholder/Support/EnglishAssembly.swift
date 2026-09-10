//
//  EnglishAssembly.swift
//  Placeholder
//

import Foundation

/// Subject, verb, object, tail: enough grammar for filler that reads as English.
enum EnglishAssembly {

    /// One sentence: an article and an optional adjective around the subject and
    /// the object, a past-tense verb between them, sometimes a tail.
    static func sentence(using generator: inout some RandomNumberGenerator) -> String {
        let subject = phrase(from: EnglishCorpus.subjects, using: &generator)
        let verb = Sampling.pick(EnglishCorpus.verbs, using: &generator)
        let object = phrase(from: EnglishCorpus.objects, using: &generator)
        var parts = [subject, verb, object]
        if Sampling.chance(0.5, using: &generator) {
            parts.append(Sampling.pick(EnglishCorpus.tails, using: &generator))
        }
        return LoremAssembly.capitalised(parts.joined(separator: " ")) + "."
    }

    /// `count` sentences on one line.
    static func paragraph(sentences count: Int, using generator: inout some RandomNumberGenerator) -> String {
        guard count > 0 else { return "" }
        var result: [String] = []
        result.reserveCapacity(count)
        for _ in 0..<count {
            result.append(sentence(using: &generator))
        }
        return result.joined(separator: " ")
    }

    /// "the quiet engineer" or "a ladder": an article, an adjective half the time, a noun.
    static func phrase(from nouns: [String], using generator: inout some RandomNumberGenerator) -> String {
        let noun = Sampling.pick(nouns, using: &generator)
        let adjective = Sampling.chance(0.5, using: &generator) ? Sampling.pick(EnglishCorpus.adjectives, using: &generator) : nil
        let head = adjective ?? noun
        let article = Sampling.chance(0.5, using: &generator) ? "the" : (head.first.map { "aeiou".contains($0) } == true ? "an" : "a")
        return [article, adjective, noun].compactMap { $0 }.joined(separator: " ")
    }
}
