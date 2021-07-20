import Foundation

struct TopCountryArtistsResponse: Codable {
    let topartists: Topartists
}

struct Topartists: Codable {
    let artist: [Artist]
}
