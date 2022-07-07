import Foundation

struct ArtistInfo: Codable {
    let bio: ArtistBio
    let ontour: String
    let stats: ArtistStats
    let mbid: String?
    let image: [LastFMImage]
    var similar: SimilarArtists
    let url: String
    let tags: Tags
    let name: String
    let streamable: String
}
