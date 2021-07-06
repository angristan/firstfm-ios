//
//  firstfmApp.swift
//  firstfm
//
//  Created by Stanislas Lange on 11/06/2021.
//

import SwiftUI

@main
struct FirstfmApp: App {
    
    @StateObject var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
            }.environmentObject(auth)
        }
    }
}
