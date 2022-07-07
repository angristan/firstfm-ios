struct Artist: Codable, Identifiable {

    var id: String {
        name
    }

    var mbid: String?
    var name: String
    var playcount: String?
    var listeners: String?
    var image: [LastFMImage]
}

struct ScrobbledArtist: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    let mbid: String
    let name: String
}

extension Artist {
    static func fixture(
            name: String = "Red Velvet",
            playcount: String = "53378137",
            listeners: String = "353237",
            image: [LastFMImage] = [.fixture()]
    ) -> Artist {
        Artist(
                name: name,
                playcount: playcount,
                listeners: listeners,
                image: image)
    }
}
