//
//  ScrobbledTrackRowView.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import SwiftUI
import Kingfisher

struct ScrobbledTrackRow: View {
    @State var track: ScrobbledTrack
    var vm = ScrobbledTrackViewModel()

    var body: some View {
        HStack {
            KFImage.url(URL(string: track.image[3].url )!)
                .resizable()
                .onSuccess { res in
                    print("Success: \(self.track.name) - \(res.cacheType)")
                }
                .onFailure { err in
                    print("Error \(self.track.name): \(err)")
                }
                .fade(duration: 1)
                .cancelOnDisappear(true)
                .cornerRadius(5)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(track.name)
                        .font(.headline)
                        .lineLimit(1)
                }
                Spacer()
                HStack {
                    Text(track.artist.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(track.date?.getRelative() ?? "Now Playing")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(alignment: .leading)
                }
            }
            Button(action: {
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                if self.track.loved == "0" {
                    self.track.loved = "1"
                    vm.loveTrack(track: self.track)
                } else {
                    self.track.loved = "0"
                    vm.unloveTrack(track: self.track)
                }
                hapticFeedback.impactOccurred()
            }) {
                if self.track.loved == "1" {
                    Image(systemName: "heart.fill").imageScale(.large).foregroundColor(Color(red: 157, green: 0, blue: 0))
                } else {
                    Image(systemName: "heart").imageScale(.large)
                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}
