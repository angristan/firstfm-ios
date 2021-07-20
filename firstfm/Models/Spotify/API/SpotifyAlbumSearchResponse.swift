struct SpotifyAlbumSearchResponse: Codable {
    var albums: SpotifyAlbumSearchResultsContainerResponse
}

struct SpotifyAlbumSearchResultsContainerResponse: Codable {
    var items: [SpotifyAlbum]
}
