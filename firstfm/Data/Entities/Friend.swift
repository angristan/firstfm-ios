//
//  Friend.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import Foundation

// Same as User but with more fields
struct Friend: Codable, Identifiable {
    var id: String { name }
    let playlists, playcount, subscriber, name: String
    let country: String
    let image: [LastFMImage ]
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
}
