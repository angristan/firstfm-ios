struct ArtistTopTracksResponse: Codable {
    var toptracks: ArtistTopTracksResponseTopTracksContainer
}

struct ArtistTopTracksResponseTopTracksContainer: Codable {
    var track: [Track]
}
