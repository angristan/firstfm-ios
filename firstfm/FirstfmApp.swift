//
//  firstfmApp.swift
//  firstfm
//
//  Created by Stanislas Lange on 11/06/2021.
//

import SwiftUI

@main
struct FirstfmApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Text("Charts")
                        Image(systemName: "list.bullet")
                    }
                Color(.purple)
                    .tabItem {
                        Text("Profile")
                        Image(systemName: "person.crop.circle")
                    }
                Color(.purple)
                    .tabItem {
                        Text("Scrobbles")
                        Image(systemName: "music.note.list")
                    }
                Color(.purple)
                    .tabItem {
                        Text("Reports")
                        Image(systemName: "chart.pie.fill")
                    }
            }
        }
    }
}
