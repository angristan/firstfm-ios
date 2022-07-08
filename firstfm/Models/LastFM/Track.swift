import Foundation

struct Track: Codable, Identifiable {
    var id: String {
        name
    }

    var name: String
    var playcount: String
    var listeners: String?
    var url: String
    var artist: TrackArtist?
    var image: [LastFMImage]
}

struct ScrobbledTrack: Codable, Identifiable, Equatable, Hashable {
    // swiftlint:disable:next operator_whitespace
    static func ==(lhs: ScrobbledTrack, rhs: ScrobbledTrack) -> Bool {
        lhs.name == rhs.name && lhs.artist == rhs.artist && lhs.date == rhs.date && lhs.loved == rhs.loved
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(artist)
        hasher.combine(date)
        hasher.combine(loved)
    }

    var id: String {
        name
    }

    var name: String
    var url: String
    var image: [LastFMImage]
    var artist: ScrobbledArtist
    var loved: String?
    let date: LastFMDate?
}

struct LastFMDate: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uts)
        hasher.combine(text)
    }

    let uts, text: String

    enum CodingKeys: String, CodingKey {
        case uts
        case text = "#text"
    }

    func getRelative() -> String {
        let unixTimestamp = Double(uts)!
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        return relativeDate
    }
}

struct TrackArtist: Codable, Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    var id: String {
        name
    }

    var mbid: String?
    var name: String
}
