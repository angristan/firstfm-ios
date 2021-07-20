//
//  SimilarArtist.swift
//  firstfm
//
//  Created by Stanislas Lange on 20/07/2021.
//

import SwiftUI
import Kingfisher

struct SimilarArtistsView: View {
    var similarArtists: [SimilarArtist]

    var body: some View {
        Section {
            Text("Similar artists").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
//                    if let artist = self.model.artist {
                        ForEach(similarArtists, id: \.name) {artist in
                            VStack {
                                KFImage.url(URL(string: artist.image[0].url )!)
                                    .resizable()
                                    .loadImmediately()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .cornerRadius(.infinity)

                                Text(artist.name).font(.subheadline)
                                    .foregroundColor(.gray).lineLimit(1)
                            }
                        }
//                    }
                }
            }
        }.padding()
    }
}
