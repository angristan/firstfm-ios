//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI

struct ChartList: View {
    @ObservedObject var charts = ChartViewModel()
    @State var loaded = false

    var body: some View {
        NavigationView {
            ZStack {
                List(charts.artists) { artist in
                    NavigationLink(
                        destination: ArtistView(artist: artist),
                        label: {
                            ArtistRow(artist: artist)
                        })
                }.navigationTitle("Artist charts").onAppear {
                    if !loaded {
                        self.charts.getChartingArtists()
                        // Prevent loading artits again when navigating
                        self.loaded = true
                    }
                }
                if charts.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct ChartList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            ChartList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
