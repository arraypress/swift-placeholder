//
//  TestSupport.swift
//  PlaceholderTests
//
//  The small helpers every suite shares. Fixed seeds throughout: a test that
//  uses the system generator can only assert shape, never a value.
//

import Foundation
import XCTest
@testable import Placeholder

/// A generator at a known seed.
func seeded(_ seed: UInt64 = 42) -> Placeholder.Generator {
    Placeholder.Generator(seed: seed)
}

/// Whether the whole of `text` matches `pattern`.
func matches(_ pattern: String, _ text: String) -> Bool {
    text.range(of: "^(?:\(pattern))$", options: .regularExpression) != nil
}

/// Every sentence of a line: split on the full stop and space that ends each one.
func sentences(in line: String) -> [String] {
    line.split(separator: ". ").map { String($0).hasSuffix(".") ? String($0) : String($0) + "." }
}

/// Round-trips a value through JSON and returns what came back.
func roundTrip<Value: Codable>(_ value: Value) throws -> Value {
    try JSONDecoder().decode(Value.self, from: JSONEncoder().encode(value))
}

/// The digits of a phone number, for counting.
func digits(_ text: String) -> String {
    text.filter(\.isNumber)
}
