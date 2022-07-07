struct ArtistAlbum: Codable, Identifiable {
    var id: String {
        name
    }

    var mbid: String?
    var name: String
    var playcount: UInt
    var url: String
    var image: [LastFMImage]
}
