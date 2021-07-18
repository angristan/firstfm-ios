//
//  Artist.swift
//  firstfm
//
//  Created by Stanislas Lange on 15/06/2021.
//

import SwiftUI
import Kingfisher

struct ArtistView: View {
    let artist: Artist
    
    @ObservedObject var model = ArtistViewModel()
    @State var albumsLoaded = false
    @State var tracksLoaded = false
    @State private var selectedKindIndex = 0
    @State private var isPullLoaderShowing = false
    
    var body: some View {
        VStack {
            KFImage(URL(string: artist.image[0].url )!).resizable().aspectRatio(1, contentMode: .fit)
            Spacer()
            Picker("Kind",
                   selection: $selectedKindIndex,
                   content: {
                    Text("Albums").tag(0)
                    Text("Tracks").tag(1)
                   }).padding(.horizontal, 20)
                .padding(.vertical, 5)
                .pickerStyle(SegmentedPickerStyle())
            
            if selectedKindIndex == 0 {
                List(model.albums) { album in
                    NavigationLink(
                        destination: Color(.red),
                        label: {
                            AlbumRow(album: album)
                        })
                }
                .onAppear {
                    if !albumsLoaded {
                        self.model.getArtistAlbums(self.artist.name)
                        // Prevent loading artists again when navigating
                        self.albumsLoaded = true
                    }
                }
                .pullToRefresh(isShowing: $isPullLoaderShowing) {
                    self.model.getArtistAlbums(self.artist.name)
                    self.isPullLoaderShowing = false
                }
            }
            
            if selectedKindIndex == 1 {
                List(model.tracks) { track in
                    NavigationLink(
                        destination: Color(.blue),
                        label: {
                            TrackRow(track: track)
                        })
                }.onAppear {
                    if !tracksLoaded {
                        self.model.getArtistTracks(self.artist.name)
                        // Prevent loading artists again when navigating
                        self.tracksLoaded = true
                    }
                }
                .pullToRefresh(isShowing: $isPullLoaderShowing) {
                    self.model.getArtistTracks(self.artist.name)
                    self.isPullLoaderShowing = false
                }
            }
            
            
        }
        // Show loader above the rest of the ZStack
        if model.isLoading {
            ProgressView()
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
