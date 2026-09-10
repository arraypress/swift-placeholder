//
//  Lorem+Options.swift
//  Placeholder
//

import Foundation

extension Lorem {

    /// How long sentences and paragraphs run.
    ///
    /// The defaults are the shape of the classic passage: sentences of six to
    /// fourteen words, paragraphs of four to seven sentences. Narrow the ranges
    /// for a caption, widen them for body copy. A bound below one is read as one.
    public struct Options: Sendable, Hashable, Codable {

        /// Words per sentence, drawn uniformly from the range for each sentence.
        public var sentenceLength: ClosedRange<Int>

        /// Sentences per paragraph, drawn uniformly for each paragraph.
        public var paragraphLength: ClosedRange<Int>

        /// Options with either range overridden; the defaults are the classic shape.
        public init(sentenceLength: ClosedRange<Int> = 6...14, paragraphLength: ClosedRange<Int> = 4...7) {
            self.sentenceLength = sentenceLength
            self.paragraphLength = paragraphLength
        }

        /// The defaults.
        public static let standard = Options()
    }
}
