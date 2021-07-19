//
//  TrackResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

struct TopTrackResponse: Codable {
    var tracks: TopTracksResponseArtistContainer
}

struct TopTracksResponseArtistContainer: Codable {
    var track: [Track]
}
