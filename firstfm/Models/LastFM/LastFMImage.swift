import Foundation

struct LastFMImage: Codable {
    var id: String {
        url
    }
    var url: String
    var size: String

    private enum CodingKeys: String, CodingKey {
        case url = "#text", size
    }
}

extension LastFMImage {
    static func fixture(url: String = "https://i.scdn.co/image/ab6761610000e5eb40ae5b4c5c35b6dfb6c0d4a3", size: String = "small") -> LastFMImage {
        LastFMImage(url: url, size: size)
    }
}
