import Foundation

struct User: Codable, Identifiable {
    var id: String {
        name
    }
    var name: String
    var playcount: String
    var image: [LastFMImage]
    let registered: UserRegistered
}

struct UserRegistered: Codable {
    let unixtime: String
    let text: Int

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
