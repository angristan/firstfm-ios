//
//  Album.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation
import SwiftUI

struct Artist: Codable, Identifiable {

    var id: String { name }

    var mbid: String
    var name: String
    var playcount: String
    var listeners: String
    var image: [LastFMImage]
}
