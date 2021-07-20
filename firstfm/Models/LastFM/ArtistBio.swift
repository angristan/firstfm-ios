import Foundation

struct ArtistBio: Codable {
    let links: ArtistBioLinks
    let content, published, summary: String
}

struct ArtistBioLinks: Codable {
    let link: ArtistBioLink
}

struct ArtistBioLink: Codable {
    let rel: String
    let href: String
}
