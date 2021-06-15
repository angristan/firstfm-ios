//
//  TrackSearchResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

struct SpotifyTrackSearchResponse: Codable {
    var tracks: SpotifyTrackSearchResultsContainerResponse
}

struct SpotifyTrackSearchResultsContainerResponse: Codable {
    var items: [SpotifyTrackSearchResultResponse]
}

struct SpotifyTrackSearchResultResponse: Codable {
    var album: SpotifyAlbum
}

struct SpotifyAlbum: Codable {
    var name: String
    var id: String
    var images: [SpotifyImage]
}
