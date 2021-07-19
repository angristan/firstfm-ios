//
//  ArtistSearchResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation

struct SpotifyArtistSearchResponse: Codable {
    var artists: SpotifyArtistSearchResultsResponse
}

struct SpotifyArtistSearchResultsResponse: Codable {
    var items: [SpotifyArtist]
}
