//
//  SimilarArtist.swift
//  firstfm
//
//  Created by Stanislas Lange on 19/07/2021.
//

import Foundation

struct SimilarArtist: Codable {
    let url: String
    let name: String
    var image: [LastFMImage]
}

struct SimilarArtists: Codable {
    var artist: [SimilarArtist]
}
