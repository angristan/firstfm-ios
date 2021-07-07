//
//  AuthViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/06/2021.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("lastfm_username") var storedUsername: String?
    
    func isLoggedIn() -> Bool {
        return storedUsername != nil
    }
}
