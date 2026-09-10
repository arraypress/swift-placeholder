//
//  Companies.swift
//  Placeholder
//

import Foundation

extension Placeholder {

    /// A company: two words that sound like a business, a legal form, and an
    /// email domain that cannot receive mail.
    public static func company(using generator: inout some RandomNumberGenerator) -> Company {
        let name = Sampling.pick(CompanyLists.firstWords, using: &generator) + " " + Sampling.pick(CompanyLists.secondWords, using: &generator)
        let suffix = Sampling.pick(CompanyLists.suffixes, using: &generator)
        let domain = Sampling.pick(EmailAssembly.reservedDomains, using: &generator)
        return Company(name: name, suffix: suffix, emailDomain: domain)
    }

    /// ``company(using:)`` with the system's randomness.
    public static func company() -> Company {
        Sampling.withSystemGenerator { company(using: &$0) }
    }
}
