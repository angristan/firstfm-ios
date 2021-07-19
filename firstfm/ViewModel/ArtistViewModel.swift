//
//  ArtistViewModel.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/17/21.
//

import Foundation
import NotificationBannerSwift

class ArtistViewModel: ObservableObject {
    @Published var albums: [ArtistAlbum] = []
    @Published var tracks: [Track] = []
    @Published var artist: ArtistInfo?
    var isAlbumsLoading = true
    var isTracksLoading = true
    var isInfoLoading = true

    var isLoading = true

    func reset() {
        self.isAlbumsLoading = true
        self.isTracksLoading = true
        self.isInfoLoading = true
    }

    func setIsLoading() {
        if !isAlbumsLoading && !isTracksLoading && !isInfoLoading {
            self.isLoading =  false
        }
    }

    func getAll(_ artist: Artist) {
        reset()

        self.getArtistAlbums(artist.name)
        self.getArtistTracks(artist.name)
        self.getArtistInfo(artist.name)
    }

    func getArtistAlbums(_ artistName: String) {
        LastFMAPI.request(lastFMMethod: "artist.getTopAlbums", args: [
            "limit": "6",
            "artist": artistName
        ]) { (data: ArtistTopAlbumsResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load albums", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.albums = self.albums
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.albums = data.topalbums.album
                    self.isAlbumsLoading = false
                    self.setIsLoading()
                }

                for (index, album) in data.topalbums.album.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "album", name: album.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                print("IMAGE: \(imageURL)")
                                self.albums[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }

    func getArtistTracks(_ artistName: String) {
        LastFMAPI.request(lastFMMethod: "artist.getTopTracks", args: [
            "limit": "5",
            "artist": artistName
        ]) { (data: ArtistTopTracksResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load tracks", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.tracks = self.tracks
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.tracks = data.toptracks.track
                    self.isTracksLoading = false
                    self.setIsLoading()
                }

                for (index, track) in data.toptracks.track.enumerated() {
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

    func getArtistInfo(_ artistName: String) {
        LastFMAPI.request(lastFMMethod: "artist.getInfo", args: [
            "artist": artistName
        ]) { (data: ArtistInfoResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to artist info", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.tracks = self.tracks
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.artist = data.artist
                    self.isInfoLoading = false
                    self.setIsLoading()
                }

                for (index, artist) in data.artist.similar.artist.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.artist?.similar.artist[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}
