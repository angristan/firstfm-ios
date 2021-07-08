//
//  SearchView.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var search = SearchViewModel()
    @State var searchString: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Start typing",
                          text: $searchString,
                          onCommit: { self.performSearch() })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: { self.performSearch() }) {
                    Image(systemName: "magnifyingglass")
                }
            }.padding()
            List {
                ForEach(search.artists) { artist in
                    ZStack {
                        Button("") {}
                        NavigationLink(
                            destination: ArtistView(artist: artist),
                            label: {
                                ArtistRow(artist: artist)
                            })
                    }
                }
            }
        }
    }
    
    func performSearch() {
        print("searching for \(searchString)")
        self.search.searchForArtist(artist: searchString)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
