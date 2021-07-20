import Foundation

struct ArtistInfo: Codable {
    let bio: ArtistBio
    let ontour: Int
    let stats: ArtistStats
    let mbid: String
    let image: [LastFMImage]
    var similar: SimilarArtists
    let url: String
    let tags: Tags
    let name, streamable: String
}
