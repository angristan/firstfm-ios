//
//  ArtistSearch.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import Foundation

struct ArtistSearchResponse: Codable {
    let results: ArtistSearchResult
}

struct ArtistSearchResult: Codable {
    let artistmatches: Artistmatches
}

struct Artistmatches: Codable {
    let artist: [Artist]
}
