//
//  NameAssembly.swift
//  Placeholder
//

import Foundation

/// What a name becomes when it is written out or abbreviated.
enum NameAssembly {

    /// Given name, a space, family name.
    static func fullName(given: String, family: String) -> String {
        [given, family].filter { !$0.isEmpty }.joined(separator: " ")
    }

    /// The first letter of each name, uppercased: Zoë Müller is ZM.
    static func initials(given: String, family: String) -> String {
        [given, family].compactMap { $0.first }.map { String($0).uppercased() }.joined()
    }
}
