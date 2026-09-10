//
//  Company+Facts.swift
//  Placeholder
//

import Foundation

extension Company {

    /// The name with its legal form: "Northwind Systems Ltd".
    public var legalName: String {
        "\(name) \(suffix)"
    }

    /// A contact address at the company's example domain.
    public var contactEmail: String {
        "hello@\(emailDomain)"
    }
}
