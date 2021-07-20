struct TopTrackResponse: Codable {
    var tracks: TopTracksResponseArtistContainer
}

struct TopTracksResponseArtistContainer: Codable {
    var track: [Track]
}
