//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI

struct ChartList: View {
    @ObservedObject var charts = ChartViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List(charts.artists) { artist in
                    ArtistRow(artist: artist)
                }.navigationTitle("Artist charts").onAppear {
                    self.charts.getChartingArtists()
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
