import Foundation

struct Tags: Codable {
    let tag: [Tag]
}

struct Tag: Codable {
    let name: String
    let url: String?
    let total, reach: Int?
    let wiki: TagWiki?
}

struct TagWiki: Codable {
    let summary, content: String
}
