//
//  Track.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

struct Track: Codable, Identifiable {
    
    var id: String { name }
    
    var name: String
    var playcount: String
    var listeners: String
    var url: String
    var artist: TrackArtist
    var image: [LastFMImage]
}

struct TrackArtist: Codable, Identifiable {

    var id: String { name }

    var mbid: String
    var name: String
}
