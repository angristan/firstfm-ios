//
//  ArtistBio.swift
//  firstfm
//
//  Created by Stanislas Lange on 19/07/2021.
//

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
