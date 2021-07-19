//
//  ScobbledTrackViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import Foundation
import SwiftUI
import NotificationBannerSwift

struct Nothing: Codable {}

class ScrobbledTrackViewModel {
    @AppStorage("lastfm_sk") var storedToken: String?

    func loveTrack(track: ScrobbledTrack) {
        LastFMAPI.request(lastFMMethod: "track.love", args: ["artist": track.artist.name, "track": track.name, "sk": storedToken ?? ""]) { (_: Nothing?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to like track", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
        }
    }

    func unloveTrack(track: ScrobbledTrack) {
        LastFMAPI.request(lastFMMethod: "track.unlove", args: ["artist": track.artist.name, "track": track.name, "sk": storedToken ?? ""]) { (_: Nothing?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to unlike track", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
        }
    }
}
