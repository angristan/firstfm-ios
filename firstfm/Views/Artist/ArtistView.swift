//
//  Artist.swift
//  firstfm
//
//  Created by Stanislas Lange on 15/06/2021.
//

import SwiftUI
import Kingfisher
import FancyScrollView

struct ArtistView: View {
    let artist: Artist

    @ObservedObject var model = ArtistViewModel()

    var body: some View {
        ZStack {
            GeometryReader { g in
                FancyScrollView(
                    title: artist.name,
                    headerHeight: 350,
                    scrollUpHeaderBehavior: .parallax,
                    scrollDownHeaderBehavior: .offset,
                    header: {
                    KFImage.url(URL(string: artist.image[0].url )!)
                        .resizable()
                        .loadImmediately()
                        .aspectRatio(contentMode: .fill)
                        .overlay(TintOverlayView().opacity(0.2))
                }
                ) {
                    VStack(alignment: .leading) {
                        ArtistInfoView(artistInfo: model.artist, artist: artist)
                            .padding()

                        TopArtistTracksView(tracks: model.tracks)
                            .frame(
                                width: g.size.width - 5,
                                height: g.size.height * 0.7,
                                alignment: .center
                            )

                        TopArtistAlbumsView(albums: model.albums).offset(y: -50)

                        SimilarArtistsView(similarArtists: model.artist?.similar.artist ?? [])
                            .offset(y: -30)

                    }.padding(.top, 10)
                        .onAppear {
                            self.model.getAll(artist)
                        }
                }.navigationTitle(artist.name)
            }.opacity(model.isLoading ? 0 : 1)

            // Show loader above the rest of the ZStack
            if model.isLoading {
                ProgressView().scaleEffect(2)
            }
        }
    }

}

struct ArtistView_Previews: PreviewProvider {

    static var previews: some View {
        if let sampleArtist = Self.sampleArtist {
            ArtistView(artist: sampleArtist)
        } else {
            Text("Failed to load sample JSON")
        }
    }

    static var sampleArtist: Artist? {
        guard let url = Bundle.main.url(
            forResource: "SampleArtist",
            withExtension: "json"
        ),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        let decoder = JSONDecoder()
        let artist = try? decoder.decode(Artist.self, from: data)

        return artist ?? nil
    }
}
