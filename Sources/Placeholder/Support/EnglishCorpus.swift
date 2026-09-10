//
//  EnglishCorpus.swift
//  Placeholder
//

import Foundation

/// Word lists for plain-English filler, grouped by the slot each fills.
///
/// Every noun is singular and every verb is past tense, so no sentence can
/// disagree with itself. The vocabulary is deliberately ordinary — nothing a
/// reader would stop on — because filler that is noticed has failed.
enum EnglishCorpus {

    /// Things that can do something.
    static let subjects: [String] = [
        "engineer", "committee", "neighbour", "cat", "librarian", "orchestra", "courier", "gardener",
        "accountant", "teacher", "pilot", "baker", "dog", "editor", "florist", "surveyor", "nurse",
        "carpenter", "cyclist", "translator", "choir", "postman", "architect", "referee", "student",
    ]

    /// Words that describe a noun.
    static let adjectives: [String] = [
        "quiet", "careful", "unexpected", "tall", "second", "borrowed", "patient", "narrow", "green",
        "early", "familiar", "heavy", "small", "wooden", "distant", "cheerful", "steady", "late",
        "yellow", "spare", "old", "modest", "curious", "empty", "final",
    ]

    /// Past-tense verbs that take an object.
    static let verbs: [String] = [
        "carried", "measured", "repaired", "described", "ignored", "painted", "counted", "opened",
        "returned", "borrowed", "photographed", "folded", "delivered", "checked", "sketched", "moved",
        "polished", "labelled", "weighed", "found", "packed", "sorted", "watched", "unlocked", "mended",
    ]

    /// Things that can have something done to them.
    static let objects: [String] = [
        "letter", "ladder", "map", "kettle", "invoice", "bicycle", "bridge", "garden", "window", "piano",
        "parcel", "clock", "boat", "lantern", "notebook", "fence", "umbrella", "engine", "basket",
        "photograph", "staircase", "violin", "suitcase", "signpost", "telescope",
    ]

    /// Where or when, to end a sentence.
    static let tails: [String] = [
        "before lunch", "without a word", "on the second floor", "after the rain", "in the wrong order",
        "by the harbour", "on Tuesday", "for the third time", "under the stairs", "at the last minute",
        "beside the river", "during the interval", "in the morning", "after some thought", "near the station",
    ]
}
