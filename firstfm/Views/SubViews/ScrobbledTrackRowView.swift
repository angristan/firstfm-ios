//
//  ScrobbledTrackRowView.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import SwiftUI
import Kingfisher

struct ScrobbledTrackRow: View {
    var track: ScrobbledTrack
    
    var body: some View {
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
            .frame(width: 50, height: 50)
        
        
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(track.date?.getRelative() ?? "Now Playing")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(alignment: .leading)
            }
            Spacer()
            Text(track.artist.name)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
