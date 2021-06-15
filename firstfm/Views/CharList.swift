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
    @State private var selectedChartsIndex = 0

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Picker("Favorite Color",
                           selection: $selectedChartsIndex,
                           content: {
                            Text("Artists").tag(0)
                            Text("Tracks").tag(1)
                           }).padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .pickerStyle(SegmentedPickerStyle())

                    List(charts.artists) { artist in
                        NavigationLink(
                            destination: ArtistView(artist: artist),
                            label: {
                                ArtistRow(artist: artist)
                            })
                    }.navigationTitle("Global charts").onAppear {
                        if !loaded {
                            self.charts.getChartingArtists()
                            // Prevent loading artits again when navigating
                            self.loaded = true
                        }
                    }
                }
                // Show loader above the rest of the ZStack
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
