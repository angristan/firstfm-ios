//
//  AlbumSearchResponse.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/18/21.
//

struct SpotifyAlbumSearchResponse: Codable {
    var albums: SpotifyAlbumSearchResultsContainerResponse
}

struct SpotifyAlbumSearchResultsContainerResponse: Codable {
    var items: [SpotifyAlbum]
}
