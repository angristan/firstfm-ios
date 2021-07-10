//
//  TopCountryArtists.swift
//  firstfm
//
//  Created by Stanislas Lange on 10/07/2021.
//

import Foundation

struct TopCountryArtistsResponse: Codable {
    let topartists: Topartists
}

struct Topartists: Codable {
    let artist: [Artist]
}
