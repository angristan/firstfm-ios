//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI

struct ChartList: View {
    @ObservedObject var charts = ChartViewModel()
    @State var artistsLoaded = false
    @State var tracksLoaded = false
    @State private var selectedChartsIndex = 0
    @State private var isPullLoaderShowing = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Picker("Favorite Color",
                           selection: $selectedChartsIndex,
                           content: {
                            // TODO use enum
                            Text("Artists").tag(0)
                            Text("Tracks").tag(1)
                           }).padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedChartsIndex == 0 {
                        List {
                            ForEach(charts.artists) { artist in
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
                        .navigationTitle("Global charts").onAppear {
                            if !artistsLoaded {
                                self.charts.getChartingArtists()
                                // Prevent loading artists again when navigating
                                self.artistsLoaded = true
                            }
                        }
                        .pullToRefresh(isShowing: $isPullLoaderShowing) {
                            self.charts.getChartingArtists()
                            self.isPullLoaderShowing = false
                        }
                    }
                    if selectedChartsIndex == 1 {
                        List(charts.tracks) { track in
                            NavigationLink(
                                destination: Color(.blue),
                                label: {
                                    TrackRow(track: track)
                                })
                        }.navigationTitle("Global charts").onAppear {
                            if !tracksLoaded {
                                self.charts.getChartingTracks()
                                // Prevent loading artists again when navigating
                                self.tracksLoaded = true
                            }
                        }
                        .pullToRefresh(isShowing: $isPullLoaderShowing) {
                            self.charts.getChartingTracks()
                            self.isPullLoaderShowing = false
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
