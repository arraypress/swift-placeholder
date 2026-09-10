//
//  NameLists.swift
//  Placeholder
//
//  Common names from a dozen countries, so a list of placeholder people looks like a list of people.
//

import Foundation

/// The names ``Placeholder/person(region:using:)`` draws from.
///
/// Diacritics are kept — Zoë and Müller are names, not typos — and stripped
/// only where they cannot go, which is the local part of an email address.
enum NameLists {

    /// Given names, mixed across English, Spanish, French, German, Italian,
    /// Portuguese, Irish, Welsh, Scottish, Polish, Dutch, Scandinavian, Greek,
    /// Turkish, Arabic, Persian, Hebrew, Indian, Chinese, Japanese, Korean,
    /// Vietnamese, Filipino, Nigerian, Ghanaian and Kenyan usage.
    static let givenNames: [String] = [
        "Aaliyah", "Aarav", "Abigail", "Adaeze", "Adam", "Adrian", "Agnieszka", "Ahmed", "Aiko", "Aisha",
        "Akira", "Alejandro", "Alice", "Amara", "Amelia", "Amir", "Ananya", "Anders", "Andrea", "Angus",
        "Anika", "Anna", "Anong", "Antoine", "Arjun", "Astrid", "Aurora", "Ayşe", "Beatriz", "Benjamin",
        "Bianca", "Björn", "Blessing", "Bo", "Bridget", "Camille", "Carlos", "Catalina", "Cerys", "Charlotte",
        "Chen", "Chiara", "Chinonso", "Chloé", "Ciarán", "Clara", "Daniel", "Dara", "David", "Declan",
        "Deniz", "Dhruv", "Diego", "Dmitri", "Dorota", "Ebele", "Eleanor", "Elena", "Eli", "Elif",
        "Elin", "Elias", "Elizabeth", "Emeka", "Emil", "Emma", "Eoin", "Esme", "Ethan", "Eva",
        "Ewan", "Farida", "Fatima", "Felix", "Fiona", "Francesca", "Freya", "Gabriel", "Georgia", "Giulia",
        "Grace", "Gwen", "Hana", "Hannah", "Hans", "Haruto", "Hassan", "Helena", "Henry", "Hiroshi",
        "Ida", "Idris", "Ines", "Ingrid", "Isabella", "Isla", "Ivan", "Jack", "Jamal", "James",
        "Jan", "Jasmine", "Javier", "Jin", "Joana", "Johan", "Jonah", "Josephine", "Juan", "Julia",
        "Jun", "Kai", "Kamala", "Karim", "Kasia", "Kenji", "Kofi", "Kwame", "Laila", "Lars",
        "Layla", "Leah", "Leila", "Leo", "Leon", "Liam", "Lin", "Linh", "Lucas", "Lucía",
        "Luis", "Luca", "Maeve", "Malik", "Marco", "Margaux", "Maria", "Mariam", "Marta", "Mateo",
        "Matthias", "Maya", "Mei", "Mia", "Miguel", "Mikael", "Mina", "Minh", "Mohammed", "Nadia",
        "Naomi", "Natalia", "Niamh", "Nikolai", "Nils", "Noah", "Noor", "Nora", "Oisín", "Olivia",
        "Omar", "Oscar", "Owen", "Paulo", "Pedro", "Petra", "Priya", "Rafael", "Rania", "Ravi",
        "Rhys", "Riya", "Rosa", "Ruben", "Ryo", "Saoirse", "Sara", "Sebastian", "Seo-yun", "Sofia",
        "Sören", "Sunita", "Tariq", "Tarō", "Teodora", "Thandiwe", "Theo", "Thomas", "Tomasz", "Tudor",
        "Uche", "Valentina", "Vera", "Victor", "Wei", "William", "Xavier", "Yara", "Yasmin", "Yuki",
        "Yusuf", "Zainab", "Zara", "Zoë", "Zofia",
    ]

    /// Surnames, mixed the same way.
    static let familyNames: [String] = [
        "Abbott", "Adebayo", "Ahmed", "Aitken", "Alvarez", "Andersen", "Andersson", "Araújo", "Bakker", "Barros",
        "Becker", "Bennett", "Berg", "Bianchi", "Blanc", "Boateng", "Brennan", "Brown", "Byrne", "Campbell",
        "Carvalho", "Castro", "Chen", "Cho", "Choi", "Clarke", "Costa", "Cruz", "Dahl", "Davies",
        "De Luca", "Delgado", "Demir", "Dias", "Doyle", "Dubois", "Dunne", "Eriksen", "Esposito", "Evans",
        "Fernández", "Ferrari", "Fischer", "Flores", "Fontaine", "Fraser", "Fujimoto", "Gallagher", "García", "Garnier",
        "Gomez", "Gonçalves", "Graham", "Greco", "Gupta", "Haddad", "Hansen", "Hassan", "Hayashi", "Hoffmann",
        "Holm", "Huang", "Hughes", "Hussain", "Ibrahim", "Ito", "Iyer", "Jansen", "Jensen", "Jiménez",
        "Johansson", "Jones", "Joshi", "Kaur", "Kelly", "Khan", "Kim", "Kobayashi", "Kowalski", "Krishnan",
        "Kumar", "Lambert", "Larsen", "Le", "Lee", "Lewis", "Li", "Lindqvist", "Liu", "Lopes",
        "López", "Lorenzo", "Lynch", "Mahmoud", "Marino", "Martin", "Martínez", "Mathews", "Mbeki", "McCarthy",
        "Meyer", "Mendes", "Mensah", "Mitchell", "Morales", "Moreau", "Morgan", "Moretti", "Müller", "Murphy",
        "Nakamura", "Nguyen", "Nielsen", "Nilsson", "Novák", "Nowak", "O'Brien", "O'Connor", "O'Neill", "Ochieng",
        "Okafor", "Okoro", "Oliveira", "Olsen", "Osei", "Otieno", "Park", "Patel", "Pereira", "Petrov",
        "Pham", "Popescu", "Price", "Quinn", "Rahman", "Ramos", "Reyes", "Ricci", "Roberts", "Rodríguez",
        "Romano", "Rossi", "Rousseau", "Ruiz", "Russo", "Ryan", "Saito", "Salah", "Sánchez", "Santos",
        "Sato", "Schmidt", "Schneider", "Schulz", "Sharma", "Silva", "Singh", "Smith", "Sousa", "Suzuki",
        "Takahashi", "Tanaka", "Taylor", "Thomas", "Torres", "Tran", "van der Berg", "van Dijk", "Varga", "Vasquez",
        "Vermeulen", "Visser", "Vo", "Wagner", "Walsh", "Wang", "Watanabe", "Weber", "Williams", "Wilson",
        "Wojcik", "Wright", "Wu", "Yamamoto", "Yang", "Yıldız", "Yoon", "Zhang", "Zhou", "Zimmermann",
    ]
}
