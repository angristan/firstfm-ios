//
//  Artist.swift
//  firstfm
//
//  Created by Stanislas Lange on 15/06/2021.
//

import SwiftUI
import Kingfisher
import FancyScrollView

struct TintOverlay: View {
    var body: some View {
        ZStack {
            Text(" ")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct ArtistView: View {
    let artist: Artist

    @ObservedObject var model = ArtistViewModel()
    @State private var selectedKindIndex = 0
    @State private var isPullLoaderShowing = false

    var body: some View {
        GeometryReader { g in
            FancyScrollView(title: artist.name,
                            headerHeight: 350,
                            scrollUpHeaderBehavior: .parallax,
                            scrollDownHeaderBehavior: .offset,
                            header: { KFImage.url(URL(string: artist.image[0].url )!).resizable().aspectRatio(contentMode: .fill).overlay(TintOverlay().opacity(0.2)) }) {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text("\(Int(artist.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(Int(artist.listeners)?.formatted() ?? "0") listeners")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text(model.artist?.bio.content ?? "rip").lineLimit(3)

                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                if let artist = self.model.artist {
                                    ForEach(artist.tags.tag, id: \.name) {tag in
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
                    }.padding()

                    List {
                        Section {
                            Text("Top tracks").font(.headline)
                            ForEach(model.tracks, id: \.name) { track in
                                NavigationLink(
                                    destination: Color(.red),
                                    label: {
                                    TrackRow(track: track)
                                })
                            }
                        }
                    }.frame(width: g.size.width - 5, height: g.size.height * 0.7, alignment: .center)
                    Section {
                        Text("Top albums").font(.headline)
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: 50, maximum: 200)),
                            GridItem(.flexible(minimum: 50, maximum: 200))
                        ], spacing: 30 ) {
                            ForEach(model.albums, id: \.name) { album in
                                NavigationLink(
                                    destination: Color(.red),
                                    label: {
                                    VStack {
                                        KFImage.url(URL(string: album.image[0].url )!).resizable()
                                            .cornerRadius(5)
                                            .aspectRatio(contentMode: .fill)
                                        Text(album.name).font(.headline).lineLimit(1).foregroundColor(.white)
                                        Text("\(String(format: "%ld", locale: Locale.current, album.playcount) ) listeners")
                                            .font(.subheadline)
                                            .foregroundColor(.gray).lineLimit(1)
                                    }
                                })

                            }
                        }
                    }.padding().offset(y: -50)

                    Section {
                        Text("Similar artists").font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                if let artist = self.model.artist {
                                    ForEach(artist.similar.artist, id: \.name) {artist in
                                        VStack {
                                            KFImage.url(URL(string: artist.image[0].url )!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipShape(Circle())
                                                .cornerRadius(.infinity)

                                            Text(artist.name).font(.subheadline)
                                                .foregroundColor(.gray).lineLimit(1)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding().offset(y: -30)
                }.padding(.top, 10)
                    .onAppear {
                        self.model.getArtistAlbums(self.artist.name)
                        self.model.getArtistTracks(self.artist.name)
                        self.model.getArtistInfo(self.artist.name)
                    }
            }.navigationTitle(artist.name)
            // Show loader above the rest of the ZStack
            if model.isLoading {
                ProgressView()
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
