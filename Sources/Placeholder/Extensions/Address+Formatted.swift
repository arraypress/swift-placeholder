//
//  Address+Formatted.swift
//  Placeholder
//

import Foundation

extension Address {

    /// The address as the lines on an envelope, joined by newlines.
    public var formatted: String {
        AddressFormatting.lines(self).joined(separator: "\n")
    }
}
