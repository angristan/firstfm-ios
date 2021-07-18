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
    var isLoading = true
    
    func reset() {
        self.isLoading = true
    }
    
    func getArtistAlbums(_ artistName: String) {
        reset()
        
        LastFMAPI.request(lastFMMethod: "artist.getTopAlbums", args: [
            "limit": "30",
            "artist": artistName,
        ]) { (data: ArtistTopAlbumsResponse?, error) -> Void in
            self.isLoading = false
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
        reset()
        
        LastFMAPI.request(lastFMMethod: "artist.getTopTracks", args: [
            "limit": "30",
            "artist": artistName,
        ]) { (data: ArtistTopTracksResponse?, error) -> Void in
            self.isLoading = false
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
}
