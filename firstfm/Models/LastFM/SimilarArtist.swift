import Foundation

struct SimilarArtist: Codable {
    let url: String
    let name: String
    var image: [LastFMImage]
}

struct SimilarArtists: Codable {
    var artist: [SimilarArtist]
}
