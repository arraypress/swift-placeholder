//
//  Placeholder.swift
//  Placeholder
//
//  The namespace: people, contacts, companies and plain-English filler that cannot belong to anyone.
//

import Foundation

/// Placeholder data that is safe by construction and reproducible by seed.
///
/// A mockup needs a name, an email address, a phone number and a street
/// address, and the usual way to get them is to type ones that look right.
/// That is how a "fake" address becomes a real person's — `john.smith@gmail.com`
/// exists, and the 555 number on the poster rings a real shop. Every value here
/// comes from a range a regulator set aside for exactly this use, or from a
/// town that only exists in fiction, so nothing generated can reach anyone.
///
/// Every generator takes a `RandomNumberGenerator`. Pass a ``Generator`` made
/// from a seed and the same calls give the same output on every run, which is
/// what a fixture wants. Leave it out and the system's randomness is used.
public enum Placeholder { }
