import Foundation

struct Tags: Codable {
    let tag: [Tag]
}

struct Tag: Codable {
    let name: String
    let url: String
}
