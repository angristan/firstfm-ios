import Foundation

// Same as User but with more fields
struct Friend: Codable, Identifiable {
    var id: String {
        name
    }
    let playlists, playcount, subscriber, name: String
    let country: String
    var image: [LastFMImage]
    let registered: Registered
    let url: String
    let realname, bootstrap: String
}

struct Registered: Codable {
    let unixtime, text: String

    enum CodingKeys: String, CodingKey {
        case unixtime
        case text = "#text"
    }

    func getRelative() -> String {
        let unixTimestamp = Double(self.unixtime)!
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        return relativeDate
    }
}
