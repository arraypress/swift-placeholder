//
//  CompanyLists.swift
//  Placeholder
//

import Foundation

/// The parts a company name is built from.
enum CompanyLists {

    /// First words: places, materials, colours, the things businesses name themselves after.
    static let firstWords: [String] = [
        "Northwind", "Cedar", "Harbour", "Blue Fern", "Granite", "Silverline", "Oakridge", "Beacon", "Copper",
        "Summit", "Meridian", "Lantern", "Tidewater", "Redfern", "Ashworth", "Brightwater", "Clearview",
        "Driftwood", "Evergreen", "Foxglove", "Greyhaven", "Hollowbrook", "Ironbridge", "Juniper",
        "Kestrel", "Longmeadow", "Marlow", "Nettlebed", "Orchard", "Pinecrest", "Quarry", "Ravenhill",
        "Saltmarsh", "Thornfield", "Upland", "Vantage", "Westbrook", "Yarrow",
    ]

    /// Second words: what the business does, or claims to.
    static let secondWords: [String] = [
        "Systems", "Holdings", "Labs", "Works", "Foods", "Partners", "Studio", "Logistics", "Analytics",
        "Textiles", "Marine", "Robotics", "Media", "Energy", "Outfitters", "Design", "Engineering",
        "Consulting", "Supply", "Ventures", "Software", "Print", "Timber", "Optics", "Freight",
    ]

    /// Legal forms. Each is real; none is tied to a region because the name is not either.
    static let suffixes: [String] = ["Ltd", "LLC", "GmbH", "Inc.", "Pty Ltd", "plc", "S.A.", "AB"]
}
