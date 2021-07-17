//
//  LoginResponse.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import SwiftUI

struct LoginResponse: Codable {
    let session: Session
}

struct Session: Codable {
    let subscriber: Int
    let name, key: String
}
