//
//  ArtistTopAlbumsResponse.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/17/21.
//

struct ArtistTopAlbumsResponse: Codable {
    var topalbums: ArtistTopAlbumsResponseTopAlbumsContainer
}

struct ArtistTopAlbumsResponseTopAlbumsContainer: Codable {
    var album: [ArtistAlbum]
}
