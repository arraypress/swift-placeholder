//
//  AddressLists.swift
//  Placeholder
//
//  Streets that could be anywhere, in towns that are nowhere.
//

import Foundation

/// The parts an address is assembled from, by region.
///
/// The towns are the ones television and novels made up — Bedford Falls,
/// Ambridge, Summer Bay — so a generated address can never be delivered, while
/// still reading like a place. Street names and regions are real kinds of
/// names; a "Maple Street" exists in most towns, which is what makes the line
/// plausible and is why the town has to carry the guarantee instead.
enum AddressLists {

    /// Street names shared by every region.
    static let streetNames: [String] = [
        "Alder", "Ash", "Beech", "Birch", "Bridge", "Brook", "Castle", "Cedar", "Chestnut", "Church",
        "Elm", "Forge", "Foundry", "Harbour", "Hawthorn", "Hazel", "Hill", "Holly", "Juniper", "Lake",
        "Larch", "Linden", "Maple", "Market", "Meadow", "Mill", "Oak", "Orchard", "Park", "Poplar",
        "Quarry", "River", "Rowan", "Spring", "Station", "Summit", "Sycamore", "Valley", "Willow", "Yew",
    ]

    /// Street types, in the words each country uses.
    static func streetTypes(for region: Region) -> [String] {
        switch region {
        case .unitedStates:  ["Street", "Avenue", "Road", "Boulevard", "Lane", "Drive", "Court", "Way", "Place"]
        case .canada:        ["Street", "Avenue", "Road", "Drive", "Crescent", "Court", "Way", "Boulevard"]
        case .unitedKingdom: ["Road", "Street", "Lane", "Close", "Avenue", "Gardens", "Crescent", "Terrace", "Way", "Grove"]
        case .ireland:       ["Road", "Street", "Lane", "Avenue", "Park", "Terrace", "Drive", "Court"]
        case .australia:     ["Street", "Road", "Avenue", "Crescent", "Court", "Drive", "Place", "Parade"]
        }
    }

    /// Towns from fiction, so none of them can take a letter.
    static func towns(for region: Region) -> [String] {
        switch region {
        case .unitedStates:
            ["Bedford Falls", "Hill Valley", "Twin Peaks", "Sunnydale", "Pawnee", "Stars Hollow", "Smallville",
             "Hawkins", "Castle Rock", "Arlen", "Quahog", "Cabot Cove", "Mayberry", "Eerie", "Bluebell",
             "Point Place", "Lanford", "Bon Temps", "Derry", "Greendale"]
        case .canada:
            ["Dog River", "Schitt's Creek", "Avonlea", "Manawaka", "Possum Lake", "Wessex Falls"]
        case .unitedKingdom:
            ["Ambridge", "Walford", "Weatherfield", "Holby", "Emmerdale", "Casterbridge", "Middlemarch",
             "Cranford", "Sandford", "Royston Vasey", "Tilling", "Barchester", "Candleford", "Portwenn",
             "Dibley", "Kingsmarkham", "Aidensfield", "Darrowby", "Lochdubh", "Tannochbrae",
             "Pontypandy", "Trumpton", "Balamory", "Summerisle", "St Mary Mead", "Market Blandings"]
        case .ireland:
            ["Ballykissangel", "Carrigstown", "Glenroe", "Killinaskully", "Craggy Island", "Ballybeg",
             "Ballymagash", "Ballydung"]
        case .australia:
            ["Summer Bay", "Erinsborough", "Wandin Valley", "Pearl Bay", "Mount Thomas", "Rosehaven",
             "Yabbie Creek", "Gungellan", "Cooper's Crossing", "Bellbird"]
        }
    }

    /// Regions: real states, provinces and counties, so the line reads right.
    static func regions(for region: Region) -> [String] {
        switch region {
        case .unitedStates:
            ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
             "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
             "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
             "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
             "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
             "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
             "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        case .canada:
            ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador",
             "Nova Scotia", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan"]
        case .unitedKingdom:
            ["Kent", "Surrey", "Devon", "Cornwall", "Norfolk", "Suffolk", "Essex", "Dorset", "Somerset",
             "Wiltshire", "Hampshire", "West Sussex", "North Yorkshire", "Lancashire", "Cumbria",
             "Northumberland", "County Durham", "Cheshire", "Derbyshire", "Nottinghamshire", "Lincolnshire",
             "Leicestershire", "Warwickshire", "Oxfordshire", "Gloucestershire", "Shropshire", "Herefordshire",
             "Worcestershire", "Staffordshire", "Berkshire", "Buckinghamshire", "Hertfordshire", "Bedfordshire",
             "Cambridgeshire", "Northamptonshire", "Fife", "Argyll and Bute", "Gwynedd", "Powys", "County Antrim"]
        case .ireland:
            ["Carlow", "Cavan", "Clare", "Cork", "Donegal", "Dublin", "Galway", "Kerry", "Kildare", "Kilkenny",
             "Laois", "Leitrim", "Limerick", "Longford", "Louth", "Mayo", "Meath", "Monaghan", "Offaly",
             "Roscommon", "Sligo", "Tipperary", "Waterford", "Westmeath", "Wexford", "Wicklow"]
        case .australia:
            ["New South Wales", "Victoria", "Queensland", "Western Australia", "South Australia", "Tasmania",
             "Australian Capital Territory", "Northern Territory"]
        }
    }
}
