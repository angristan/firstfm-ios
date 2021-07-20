import Foundation

struct ArtistSearchResponse: Codable {
    let results: ArtistSearchResult
}

struct ArtistSearchResult: Codable {
    let artistmatches: Artistmatches
}

struct Artistmatches: Codable {
    let artist: [Artist]
}
