//
//  User.swift
//  firstfm
//
//  Created by Stanislas Lange on 06/07/2021.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String { name }
    var name: String
    var playcount: String
    var image: [LastFMImage]
}
