import Foundation

struct LastFMImage: Codable {
    var id: String { url }
    var url: String
    var size: String

    private enum CodingKeys: String, CodingKey {
        case url = "#text", size
    }
}
