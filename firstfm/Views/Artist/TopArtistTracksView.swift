//
//  TopArtistTracks.swift
//  firstfm
//
//  Created by Stanislas Lange on 20/07/2021.
//

import SwiftUI

struct TopArtistTracksView: View {
    var tracks: [Track]

    var body: some View {
        List {
            Section {
                Text("Top tracks").font(.headline)
                ForEach(tracks, id: \.name) { track in
                    NavigationLink(
                        destination: Color(.red),
                        label: {
                        TrackRow(track: track)
                    })
                }
            }
        }
    }
}
