//
//  ScobbledTrackViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import Foundation
import SwiftUI
import NotificationBannerSwift
import Valet

struct Nothing: Codable {}

class ScrobbledTrackViewModel {
    let myValet = getValet()

    func loveTrack(track: ScrobbledTrack) {
        let storedToken = try? myValet.string(forKey: "sk")

        LastFMAPI.request(lastFMMethod: "track.love", args: ["artist": track.artist.name, "track": track.name, "sk": storedToken ?? ""]) { (_: Nothing?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to like track", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
        }
    }

    func unloveTrack(track: ScrobbledTrack) {
        let storedToken = try? myValet.string(forKey: "sk")

        LastFMAPI.request(lastFMMethod: "track.unlove", args: ["artist": track.artist.name, "track": track.name, "sk": storedToken ?? ""]) { (_: Nothing?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to unlike track", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
        }
    }
}
