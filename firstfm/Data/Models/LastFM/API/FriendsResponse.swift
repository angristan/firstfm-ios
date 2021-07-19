//
//  FriendsResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import Foundation

// MARK: - FriendsResponse
struct FriendsResponse: Codable {
    let friends: Friends
}

// MARK: - Friends
struct Friends: Codable {
    let user: [Friend]
}
