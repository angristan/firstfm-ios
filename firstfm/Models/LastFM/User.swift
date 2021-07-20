import Foundation

struct User: Codable, Identifiable {
    var id: String { name }
    var name: String
    var playcount: String
    var image: [LastFMImage]
}
