import Foundation

struct UserTopArtistsResponse: Codable {
    let topartists: TopartistsContainer
}

struct TopartistsContainer: Codable {
    let artist: [Artist]
}
