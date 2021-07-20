struct SpotifyTrackSearchResponse: Codable {
    var tracks: SpotifyTrackSearchResultsContainerResponse
}

struct SpotifyTrackSearchResultsContainerResponse: Codable {
    var items: [SpotifyTrackSearchResultResponse]
}

struct SpotifyTrackSearchResultResponse: Codable {
    var album: SpotifyAlbum
}
