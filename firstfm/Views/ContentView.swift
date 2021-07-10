//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ChartList()
            .tabItem {
                Text("Charts")
                Image(systemName: "list.bullet")
            }
    
        ProfileView()
            .tabItem {
                Text("Profile")
                Image(systemName: "person.crop.circle")
            }
        Scrobbles()
            .tabItem {
                Text("Scrobbles")
                Image(systemName: "music.note.list")
            }
        TrendsMapView()
            .tabItem {
                Text("Trends")
                Image(systemName: "map")
            }
        SearchView()
            .tabItem {
                Text("Search")
                Image(systemName: "magnifyingglass")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
