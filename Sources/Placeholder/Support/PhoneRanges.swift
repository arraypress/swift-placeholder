//
//  PhoneRanges.swift
//  Placeholder
//
//  The numbers regulators set aside so that fiction never rings a real phone.
//

import Foundation

/// Every phone block the package will generate from, by region, with its source.
///
/// A number outside these lists can belong to somebody. A number inside them
/// cannot: each block was reserved by the national regulator for drama,
/// advertising and documentation, and is never assigned to a subscriber.
enum PhoneRanges {

    /// The blocks for a region.
    static func blocks(for region: Region) -> [PhoneBlock] {
        switch region {
        case .unitedStates:  unitedStates
        case .canada:        canada
        case .unitedKingdom: unitedKingdom
        case .ireland:       ireland
        case .australia:     australia
        }
    }

    /// NANPA reserves 555-0100 through 555-0199 for fictional use in every
    /// area code (NANP 555 line-number assignment guidelines). The area codes
    /// here are real ones, which keeps the number looking local; the exchange
    /// and line are what make it safe.
    static let unitedStates: [PhoneBlock] = ["212", "213", "312", "415", "512", "617", "702", "801", "904", "206"]
        .map { PhoneBlock(lead: "(\($0)) 555-01", width: 2, range: 0...99) }

    /// The same NANPA block in Canadian area codes.
    static let canada: [PhoneBlock] = ["416", "604", "514", "403", "613", "902", "780", "306"]
        .map { PhoneBlock(lead: "(\($0)) 555-01", width: 2, range: 0...99) }

    /// Ofcom's ranges for use in drama: a thousand numbers in each of the
    /// large cities, the 01632 area that does not exist, 07700 900xxx for
    /// mobiles and 0808 157 0xxx for freephone (Ofcom, *Telephone numbers for
    /// use in TV and radio drama programmes*).
    static let unitedKingdom: [PhoneBlock] = [
        PhoneBlock(lead: "01632 960", width: 3, range: 0...999),
        PhoneBlock(lead: "020 7946 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0113 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0114 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0115 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0116 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0117 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0118 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0121 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0131 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0141 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0151 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0161 496 0", width: 3, range: 0...999),
        PhoneBlock(lead: "0191 498 0", width: 3, range: 0...999),
        PhoneBlock(lead: "028 9018 0", width: 3, range: 0...999),
        PhoneBlock(lead: "029 2018 0", width: 3, range: 0...999),
        PhoneBlock(lead: "07700 900", width: 3, range: 0...999),
        PhoneBlock(lead: "0808 157 0", width: 3, range: 0...999),
    ]

    /// ComReg reserves 020 910 0000–9999 for drama and 089 011 0000–0999 for
    /// fictional mobiles (ComReg, *Numbering Conventions*).
    static let ireland: [PhoneBlock] = [
        PhoneBlock(lead: "020 910 ", width: 4, range: 0...9999),
        PhoneBlock(lead: "089 011 0", width: 3, range: 0...999),
    ]

    /// ACMA reserves the 5550 xxxx and 7010 xxxx exchanges in every area
    /// code, thirty specific mobile numbers, and eleven 1800 and 1300 numbers
    /// (ACMA, *Phone numbers for use in TV shows, films and creative works*).
    /// The mobiles are listed one by one because that is how ACMA reserved
    /// them — a made-up 0491 57x number outside the list may be somebody's.
    static let australia: [PhoneBlock] = {
        var blocks: [PhoneBlock] = []
        for area in ["02", "03", "07", "08"] {
            for exchange in ["5550", "7010"] {
                blocks.append(PhoneBlock(lead: "(\(area)) \(exchange) ", width: 4, range: 0...9999))
            }
        }
        let mobiles = [
            "0491 570 006", "0491 570 110", "0491 570 156", "0491 570 157", "0491 570 158", "0491 570 159",
            "0491 570 313", "0491 570 737", "0491 571 266", "0491 571 491", "0491 571 804", "0491 572 549",
            "0491 572 665", "0491 572 983", "0491 573 087", "0491 573 770", "0491 574 118", "0491 574 632",
            "0491 575 254", "0491 575 789", "0491 576 398", "0491 576 801", "0491 577 426", "0491 577 644",
            "0491 578 148", "0491 578 888", "0491 578 957", "0491 579 212", "0491 579 455", "0491 579 760",
        ]
        let special = [
            "1800 160 401", "1800 975 707", "1800 975 708", "1800 975 709", "1800 975 710", "1800 975 711",
            "1300 975 707", "1300 975 708", "1300 975 709", "1300 975 710", "1300 975 711",
        ]
        for number in mobiles + special {
            blocks.append(PhoneBlock(lead: number, width: 0, range: 0...0))
        }
        return blocks
    }()
}
