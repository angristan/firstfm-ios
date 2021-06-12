//
//  Album.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation
import SwiftUI

struct Artist: Hashable, Codable, Identifiable {
    var id: String { name }

    var mbid: String
    var name: String
}
