import Foundation

struct Track: Codable, Identifiable {
    var id: String { name }

    var name: String
    var playcount: String
    var listeners: String?
    var url: String
    var artist: TrackArtist?
    var image: [LastFMImage]
}

struct ScrobbledTrack: Codable, Identifiable {

    var id: String { name }

    var name: String
    var url: String
    var image: [LastFMImage]
    var artist: ScrobbledArtist
    var loved: String?
    let date: LastFMDate?
}

struct LastFMDate: Codable {
    let uts, text: String

    enum CodingKeys: String, CodingKey {
        case uts
        case text = "#text"
    }

    func getRelative() -> String {
        let unixTimestamp = Double(self.uts)!
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        return relativeDate
    }
}

struct TrackArtist: Codable, Identifiable {

    var id: String { name }

    var mbid: String?
    var name: String
}
