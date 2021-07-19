//
//  ArtistResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

struct TopArtistsResponse: Codable {
    var artists: ArtistsResponseContainer
}

struct ArtistsResponseContainer: Codable {
    var artist: [Artist]
}
