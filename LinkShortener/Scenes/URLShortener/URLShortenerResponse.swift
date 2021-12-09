struct URLShortenerResponse: Codable, Equatable {
    let alias: String
    let originalURL: String
    let shortURL: String
    
    enum CodingKeys: String, CodingKey {
        case alias
        case links = "_links"
        case originalURL = "self"
        case shortURL = "short"
    }
    
    init(alias: String, originalURL: String, shortURL: String) {
        self.alias = alias
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alias = try container.decode(String.self, forKey: .alias)
        let links = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .links)
        originalURL = try links.decode(String.self, forKey: .originalURL)
        shortURL = try links.decode(String.self, forKey: .shortURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alias, forKey: .alias)
        var links = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .links)
        try links.encode(originalURL, forKey: .originalURL)
        try links.encode(shortURL, forKey: .shortURL)
    }
}

struct URLResponse: Decodable {
    let url: String
}
