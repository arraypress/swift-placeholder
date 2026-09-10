//
//  Lorem.swift
//  Placeholder
//
//  Latin filler by exact count.
//

import Foundation

/// Lorem ipsum by the word, the sentence, the paragraph, or the character.
///
/// The classic passage is a scrambled Cicero, and the point of it has not
/// changed since the 1500s: it has the letter frequencies and word lengths of
/// real prose without meaning, so the eye judges the layout and not the text.
/// What generators usually get wrong is the count — "120 characters" comes back
/// as 118, or 120 with a word cut in half. ``characters(_:options:using:)`` is
/// exact, and it ends on a whole word.
public enum Lorem {

    /// The first clause everyone recognises, so a reader knows the text is filler.
    ///
    /// Passed to ``text(paragraphs:startingWithClassic:options:using:)``, it
    /// becomes the opening sentence; the rest is drawn from the same vocabulary.
    public static let classicOpening = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
}
