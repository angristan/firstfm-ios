import SwiftUI

struct TopArtistTracksView: View {
    var tracks: [Track]

    var body: some View {
        List {
            Section {
                Text("Top tracks").font(.headline).unredacted()
                if !tracks.isEmpty {
                    ForEach(tracks, id: \.name) { track in
                        NavigationLink(
                            destination: TrackView(track: track),
                            label: {
                            TrackRow(track: track)
                        })
                    }
                } else {
                    // Placeholder for redacted
                    ForEach((1...5), id: \.self) {_ in
                        NavigationLink(
                            destination: Color(.red),
                            label: {
                            TrackRow(track: Track(name: "toto", playcount: "123", listeners: "123", url: "123", artist: nil, image: [LastFMImage(url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp", size: "lol")]))
                        })
                    }
                }

            }
        }.hasScrollEnabled(false)
    }
}
