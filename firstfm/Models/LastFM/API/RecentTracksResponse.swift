import Foundation

struct RecentTracksResponse: Codable {
    var recentTracks: RecentTracks

    enum CodingKeys: String, CodingKey {
        case recentTracks = "recenttracks"
    }
}

struct RecentTracks: Codable {
    var track: [ScrobbledTrack]
    let attr: RecenttracksAttr

    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case track
    }
}

struct RecenttracksAttr: Codable {
    let page, perPage, user, total: String
    let totalPages: String
}
