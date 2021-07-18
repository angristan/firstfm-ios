//
//  ArtistAlbum.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/17/21.
//

struct ArtistAlbum: Codable, Identifiable {
    var id: String { name }

    var mbid: String?
    var name: String
    var playcount: UInt
    var url: String
    var image: [LastFMImage]
}
