//
//  LastFMImage.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation

struct LastFMImage: Codable {
    var id: String { url }
    var url: String
    var size: String

    private enum CodingKeys: String, CodingKey {
        case url = "#text", size
    }
}
