import Foundation

struct SpotifyArtistSearchResponse: Codable {
    var artists: SpotifyArtistSearchResultsResponse
}

struct SpotifyArtistSearchResultsResponse: Codable {
    var items: [SpotifyArtist]
}
