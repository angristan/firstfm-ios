struct Artist: Codable, Identifiable {

    var id: String { name }

    var mbid: String?
    var name: String
    var playcount: String?
    var listeners: String?
    var image: [LastFMImage]
}

struct ScrobbledArtist: Codable {
    let mbid: String
    let name: String
}
