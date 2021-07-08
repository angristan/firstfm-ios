//
//  RecentTracksResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import Foundation

struct RecentTracksResponse: Codable {
    var recentTracks: RecentTracks
    
    enum CodingKeys: String, CodingKey {
        case recentTracks = "recenttracks"
    }
}

struct RecentTracks: Codable {
    var track: [ScrobbledTrack]
}
