//
//  ArtistInfoView.swift
//  firstfm
//
//  Created by Stanislas Lange on 20/07/2021.
//

import SwiftUI

struct ArtistInfoView: View {

    var artistInfo: ArtistInfo?
    var artist: Artist

    var body: some View {
        HStack {
            Text("\(Int(artist.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(Int(artist.listeners)?.formatted() ?? "0") listeners")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        Text(artistInfo?.bio.content ?? "").lineLimit(3)

        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                if let artistInfo = artistInfo {
                    ForEach(artistInfo.tags.tag, id: \.name) {tag in
                        Button(action: {}) {
                            HStack {
                                Text(tag.name)
                            }
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                        .lineLimit(1)
                    }
                }
            }
        }
    }
}
