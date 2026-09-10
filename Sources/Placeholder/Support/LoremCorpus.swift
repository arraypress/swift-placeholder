//
//  LoremCorpus.swift
//  Placeholder
//
//  The vocabulary, and an index of it by word length for exact-length text.
//

import Foundation

/// The words of the classic passage and the wider vocabulary generators draw on.
///
/// There is a word of every length from one to thirteen letters. That is not
/// decoration: ``Lorem/characters(_:options:using:)`` fits its last word to the
/// characters left, and a missing length would force a cut mid-word.
enum LoremCorpus {

    /// Every word, lowercase, no punctuation.
    static let words: [String] = [
        "a", "ac", "ad", "adipiscing", "aenean", "aliqua", "aliquam", "aliquip", "amet", "anim",
        "ante", "arcu", "at", "aute", "bibendum", "blandit", "cillum", "commodo", "congue",
        "consectetur", "consequat", "convallis", "cras", "culpa", "cupidatat", "curabitur", "cursus",
        "dapibus", "deserunt", "diam", "dictum", "dignissim", "do", "dolor", "dolore", "donec", "duis",
        "ea", "egestas", "eget", "eiusmod", "eleifend", "elementum", "elit", "enim", "erat", "eros",
        "esse", "est", "et", "etiam", "eu", "euismod", "ex", "excepteur", "exercitation", "facilisis",
        "faucibus", "fermentum", "feugiat", "fugiat", "fusce", "gravida", "hendrerit", "iaculis", "id",
        "imperdiet", "in", "incididunt", "integer", "interdum", "ipsum", "irure", "justo", "laboris",
        "labore", "laborum", "lacinia", "lacus", "laoreet", "lectus", "leo", "libero", "ligula",
        "lobortis", "lorem", "luctus", "maecenas", "magna", "malesuada", "massa", "mattis", "mauris",
        "metus", "mi", "minim", "molestie", "mollit", "morbi", "nam", "nec", "neque", "nibh", "nisi",
        "nisl", "non", "nostrud", "nulla", "nullam", "nunc", "occaecat", "odio", "officia", "orci",
        "ornare", "pariatur", "pellentesque", "phasellus", "placerat", "porta", "porttitor", "posuere",
        "praesent", "pretium", "proident", "proin", "pulvinar", "purus", "quam", "qui", "quis",
        "quisque", "reprehenderit", "rhoncus", "risus", "rutrum", "sagittis", "sapien", "scelerisque",
        "sed", "sem", "semper", "sint", "sit", "sodales", "sollicitudin", "sunt", "suscipit",
        "suspendisse", "tellus", "tempor", "tempus", "tincidunt", "tortor", "tristique", "turpis",
        "ullamco", "ullamcorper", "ultrices", "ultricies", "urna", "ut", "varius", "vehicula", "vel",
        "velit", "venenatis", "veniam", "vestibulum", "vitae", "vivamus", "voluptate", "vulputate",
    ]

    /// The vocabulary grouped by length, for fitting a word to a gap.
    static let wordsByLength: [Int: [String]] = Dictionary(grouping: words, by: \.count)

    /// The longest word, which bounds how far an exact-length cut can fall inside one.
    static let longestWordLength = words.map(\.count).max() ?? 0

    /// A word of exactly `length` letters, or nil when the vocabulary has none.
    static func word(ofLength length: Int, using generator: inout some RandomNumberGenerator) -> String? {
        guard let candidates = wordsByLength[length], !candidates.isEmpty else { return nil }
        return Sampling.pick(candidates, using: &generator)
    }
}
