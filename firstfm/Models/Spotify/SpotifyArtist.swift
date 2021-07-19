//
//  SpotifyArtist.swift
//  firstfm
//
//  Created by Stanislas Lange on 19/07/2021.
//

import Foundation

struct SpotifyArtist: Codable {
    var name: String
    var id: String
    var images: [SpotifyImage]
}
