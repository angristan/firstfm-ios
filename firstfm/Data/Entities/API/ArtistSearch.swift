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

// MARK: - Results
struct ArtistSearchResult: Codable {
    let artistmatches: Artistmatches
}

// MARK: - Artistmatches
struct Artistmatches: Codable {
    let artist: [Artist]
}
