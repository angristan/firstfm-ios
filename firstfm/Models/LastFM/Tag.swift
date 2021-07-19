//
//  Tag.swift
//  firstfm
//
//  Created by Stanislas Lange on 19/07/2021.
//

import Foundation

struct Tags: Codable {
    let tag: [Tag]
}

struct Tag: Codable {
    let name: String
    let url: String
}
