//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation
import NotificationBannerSwift

class ChartViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    @Published var tracks: [Track] = []
    var isLoading = true

    func reset() {
        self.isLoading = true
    }

    func getChartingArtists() {
        reset()

        LastFMAPI.request(lastFMMethod: "chart.getTopArtists", args: ["limit": "30"]) { (data: ArtistResponse?, error) -> Void in
            self.isLoading = false

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load charts", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.artists = self.artists
                }
            }

            if let data = data {
                var artists = data.artists.artist

                for index in artists.indices() where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.artists = artists
                }

                for (index, artist) in data.artists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.artists[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }

    func getChartingTracks() {
        reset()

        LastFMAPI.request(lastFMMethod: "chart.getTopTracks", args: ["limit": "30"]) { (data: TrackResponse?, error) -> Void in
            self.isLoading = false
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load charts", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.tracks = self.tracks
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.tracks = data.tracks.track
                }

                for (index, track) in data.tracks.track.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "track", name: track.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.tracks[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}
