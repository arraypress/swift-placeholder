//
//  EmailAssembly.swift
//  Placeholder
//
//  Local parts that any mail system accepts, at domains no mail system delivers to.
//

import Foundation

/// Email addresses at the domains RFC 2606 reserved for documentation.
///
/// `example.com`, `.org`, `.net` and `.edu` are held by IANA and can never be
/// registered, so an address at one of them can never be somebody's. The local
/// part is folded to ASCII letters, digits and a single dot, which is the
/// subset every validator agrees on; a name like O'Brien or van der Berg
/// becomes `obrien` or `vanderberg` rather than something a form rejects.
enum EmailAssembly {

    /// The four documentation domains, and nothing else.
    static let reservedDomains = ["example.com", "example.org", "example.net", "example.edu"]

    /// A name reduced to lowercase ASCII letters and digits.
    static func asciiWord(_ name: String) -> String {
        name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
            .lowercased()
            .filter { $0.isASCII && ($0.isLetter || $0.isNumber) }
    }

    /// `given.family` plus an optional numeric suffix, never starting or ending with a dot.
    static func localPart(givenName: String, familyName: String, suffix: String) -> String {
        let parts = [asciiWord(givenName), asciiWord(familyName)].filter { !$0.isEmpty }
        let joined = parts.isEmpty ? "user" : parts.joined(separator: ".")
        return joined + suffix
    }

    /// The whole address.
    static func address(givenName: String, familyName: String, suffix: String, domain: String) -> String {
        localPart(givenName: givenName, familyName: familyName, suffix: suffix) + "@" + domain
    }
}
