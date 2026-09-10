//
//  People.swift
//  Placeholder
//
//  People and their email addresses.
//

import Foundation

extension Placeholder {

    /// A person with a name, an email address and a phone number for `region`.
    ///
    /// The name is drawn from ``NameLists``; the email is at an RFC 2606 domain;
    /// the phone is from the region's reserved range. Nothing about the person
    /// can be looked up, dialled or delivered to.
    public static func person(region: Region = .unitedStates, using generator: inout some RandomNumberGenerator) -> Person {
        let given = Sampling.pick(NameLists.givenNames, using: &generator)
        let family = Sampling.pick(NameLists.familyNames, using: &generator)
        let email = email(givenName: given, familyName: family, using: &generator)
        let phone = phone(region: region, using: &generator)
        return Person(givenName: given, familyName: family, email: email, phone: phone)
    }

    /// ``person(region:using:)`` with the system's randomness.
    public static func person(region: Region = .unitedStates) -> Person {
        Sampling.withSystemGenerator { person(region: region, using: &$0) }
    }

    /// Another address for `person`, at one of the example domains — for a
    /// second field, a work address, or a list of aliases.
    public static func email(for person: Person, using generator: inout some RandomNumberGenerator) -> String {
        email(givenName: person.givenName, familyName: person.familyName, using: &generator)
    }

    /// ``email(for:using:)`` with the system's randomness.
    public static func email(for person: Person) -> String {
        Sampling.withSystemGenerator { email(for: person, using: &$0) }
    }

    /// An address built from a name: `given.family@example.org`, sometimes with
    /// a two-digit suffix the way real addresses have, always at a domain that
    /// cannot receive mail.
    public static func email(givenName: String, familyName: String, using generator: inout some RandomNumberGenerator) -> String {
        let suffix = Sampling.chance(0.35, using: &generator) ? String(Sampling.int(in: 2...99, using: &generator)) : ""
        let domain = Sampling.pick(EmailAssembly.reservedDomains, using: &generator)
        return EmailAssembly.address(givenName: givenName, familyName: familyName, suffix: suffix, domain: domain)
    }

    /// ``email(givenName:familyName:using:)`` with the system's randomness.
    public static func email(givenName: String, familyName: String) -> String {
        Sampling.withSystemGenerator { email(givenName: givenName, familyName: familyName, using: &$0) }
    }
}
