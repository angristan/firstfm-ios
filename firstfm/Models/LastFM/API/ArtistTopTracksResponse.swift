//
//  ArtistTopTracksResponse.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/17/21.
//

struct ArtistTopTracksResponse: Codable {
    var toptracks: ArtistTopTracksResponseTopTracksContainer
}

struct ArtistTopTracksResponseTopTracksContainer: Codable {
    var track: [Track]
}
