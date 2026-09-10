# Swift Placeholder

Placeholder text and placeholder data that is safe by construction and reproducible by seed.

```swift
import Placeholder

var generator = Placeholder.Generator(seed: 42)

Lorem.characters(120, using: &generator)   // exactly 120 characters, ending on a whole word
Lorem.text(paragraphs: 3, using: &generator) // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. …"

let person = Placeholder.person(region: .unitedKingdom, using: &generator)
person.fullName    // "Niamh Okafor"
person.email       // "niamh.okafor@example.org"   — a domain nobody can register
person.phone       // "07700 900482"               — Ofcom's drama range

Placeholder.address(region: .unitedStates, using: &generator).formatted
// 412 Cedar Lane
// Hill Valley
// Oregon 00317
// United States
```

Run it again with seed 42 and every value is the same.

## Why

A mockup needs contact details, and the usual way to get them is to type ones that look right.
Each of these has happened to somebody:

| What was typed | What it actually is |
|---|---|
| `john.smith@gmail.com` on a signup form fixture | A real person's inbox, and the test suite emails it |
| `555-1234` on a poster | Only 555-0100 to 555-0199 are reserved for fiction; the rest can be assigned, and are |
| A fixture built from `Int.random` | Different every run, so the snapshot test that failed on Tuesday passes on Wednesday |
| "120 characters of lorem" from a generator | 118 characters, or 120 with `consectet` cut off at the end |

Every email here is at a domain IANA holds for documentation. Every phone number is inside a range
a regulator reserved for drama. Every town is one that only exists on television. And every
value comes from a seed, so a fixture is the same on every machine and every run.

## Installation

```swift
.package(url: "https://github.com/arraypress/swift-placeholder.git", from: "0.1.0")
```

Foundation only. No dependencies, every Apple platform, macOS 14+.

## Seeds

```swift
var generator = Placeholder.Generator(seed: 7)   // SplitMix64, from the 2014 paper
let a = Lorem.words(5, using: &generator)

var again = Placeholder.Generator(seed: 7)
let b = Lorem.words(5, using: &again)             // a == b, always
```

Every function comes in two spellings: one that takes `using generator: inout`, and one that
takes nothing and uses the system's randomness. The seeded one is for fixtures; the other is for
a preview that should look different each time it opens. Nothing in the package reads the clock
or any other state, so the promise holds across every generator in sequence — a whole fixture of
people, addresses and copy reproduces from one seed.

Sampling is done here rather than through the standard library's `randomElement(using:)`, whose
mapping from 64 bits to a range has changed between Swift releases. The same seed gives the same
output on every toolchain, not only the one it was written on.

## Lorem ipsum

```swift
Lorem.words(7)                              // "dolor sit amet velit tempor enim quis"
Lorem.sentences(3)                          // three, each capitalised, each ending in a full stop
Lorem.paragraphs(2)                         // two, one blank line between
Lorem.text(paragraphs: 3)                   // opens with the classic sentence
Lorem.text(paragraphs: 3, startingWithClassic: false)
Lorem.characters(280)                       // exactly 280
Lorem.markdown(paragraphs: 2)               // the same text — plain paragraphs are already Markdown
Lorem.html(paragraphs: 2)                   // <p>…</p> per paragraph, one per line
```

`Lorem.Options` sets how long sentences and paragraphs run — six to fourteen words and four to
seven sentences by default, the shape of the original passage. A bound below one is read as one.

The classic opening appears exactly once, at the front of the first paragraph, and never in
`paragraphs` or `sentences`, which are for copy that should not announce itself as filler.

### Exact length

`characters(_:)` is exact and ends on a whole word. Text is generated past the length and walked
word by word for as long as the next word fits; what remains is a gap of known size, and each
size has one fix — a full stop, a word one letter longer, or a space and a word of exactly the
remaining length. That last step works because the vocabulary has a word of every length from
one letter to thirteen, which a test pins so that it stays true.

## People

```swift
let person = Placeholder.person(region: .ireland)
person.givenName    // "Saoirse"
person.familyName   // "O'Brien"
person.initials     // "SO"
person.email        // "saoirse.obrien@example.net"
person.phone        // "020 910 4471"

Placeholder.email(for: person)                          // another address, same domains
Placeholder.email(givenName: "Zoë", familyName: "Müller") // "zoe.muller@example.com"
```

Names are common ones from a dozen countries, diacritics kept. In the email they fold to plain
ASCII letters, digits and single dots — the subset every validator accepts — so O'Brien becomes
`obrien` rather than something a form rejects.

## Phone numbers

```swift
Placeholder.phone(region: .unitedStates)    // "(415) 555-0137"
Placeholder.phone(region: .canada)          // "(604) 555-0192"
Placeholder.phone(region: .unitedKingdom)   // "0161 496 0523", "07700 900118", "0808 157 0044"
Placeholder.phone(region: .ireland)         // "020 910 8830", "089 011 0207"
Placeholder.phone(region: .australia)       // "(02) 5550 3391", "0491 570 156", "1800 975 708"
```

Each is formatted the way its country writes numbers, and each is inside a block listed in the
next section. The Australian mobiles are drawn from ACMA's list one by one, because that is how
ACMA reserved them — a made-up `0491 57x` number outside the list may be somebody's.

## Addresses

```swift
let address = Placeholder.address(region: .unitedKingdom)
address.line1       // "88 Hawthorn Close"
address.city        // "Ambridge"
address.region      // "Devon"
address.postcode    // "XX41 7QT"
address.country     // "United Kingdom"
address.formatted   // the four lines, joined by newlines
```

Two parts carry the guarantee. The town is one from television or literature — Bedford Falls,
Walford, Summer Bay, Craggy Island — so nothing can be delivered there. The postcode is from a
range or shape the postal service never assigns, per region below. The street and the region are
plausible only: a Maple Street exists in most towns, and the region is a real state, province or
county so the address reads correctly.

## Companies

```swift
let company = Placeholder.company()
company.name          // "Northwind Robotics"
company.suffix        // "GmbH"
company.legalName     // "Northwind Robotics GmbH"
company.contactEmail  // "hello@example.com"
```

## Plain English

```swift
Placeholder.sentence()                // "The careful librarian repaired an old kettle before lunch."
Placeholder.paragraph(sentences: 3)
```

For the mockup where Latin looks wrong. A small grammar over ordinary words: singular nouns,
past-tense verbs, an article that agrees with what follows it, and nothing worth reading.

## Safe by construction

| Value | Range | Who reserved it |
|---|---|---|
| Email domains | `example.com`, `example.org`, `example.net`, `example.edu` | IANA, RFC 2606 |
| US and Canadian numbers | 555-0100 to 555-0199 in any area code | NANPA, 555 line-number assignment guidelines |
| UK numbers | 0113/0114/0115/0116/0117/0118/0121/0131/0141/0151/0161 496 0000–0999; 0191 498 0000–0999; 020 7946 0000–0999; 028 9018 0000–0999; 029 2018 0000–0999; 01632 960000–960999; 07700 900000–900999; 0808 157 0000–0999 | Ofcom, *Telephone numbers for use in TV and radio drama programmes* |
| Irish numbers | 020 910 0000–9999; 089 011 0000–0999 | ComReg, *Numbering Conventions* |
| Australian numbers | (02), (03), (07), (08) 5550 0000–9999 and 7010 0000–9999; thirty listed 0491 57x xxx mobiles; 1800 160 401, 1800 975 707–711, 1300 975 707–711 | ACMA, *Phone numbers for use in TV shows, films and creative works* |
| US ZIP codes | 00100–00499 | Below 00501, the lowest assigned ZIP code. Unassigned as of writing; the USPS could assign it. |
| UK postcodes | `XX` area | Royal Mail never uses Q, V or X as a first letter, so no XX postcode can exist. Strict format validators reject it for the same reason. |
| Canadian postal codes | first letter `Z` | No province is Z. The same caveat about strict validators applies. |
| Irish Eircodes | routing key `Z99` | No routing key begins with Z. |
| Towns | Ambridge, Bedford Falls, Erinsborough, Dog River, Carrigstown and their neighbours | Television and novels |

Australian postcodes are the one gap: Australia has reserved none, so the four digits generated
are merely plausible and an address there may collide with a real postcode. The doc comment on
`Postcodes` says so, and so does this line.

## Tested

87 tests. Exactness is checked for every length from one to three hundred characters over three
seeds, with the last word looked up in the vocabulary each time. Every phone region is drawn
thousands of times and every one of its reserved blocks must be hit at least once, and every
number must sit inside one. Every email over five hundred seeds is at a reserved domain with an
RFC-clean local part. Every postcode matches the rule that makes it safe. The seed is checked
against SplitMix64's published first output, and a whole fixture — every generator in turn —
reproduces from one seed and changes with another.

## Licence

MIT.
