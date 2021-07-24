import SwiftUI

struct LastUserScrobblesView: View {

    var scrobbles: [ScrobbledTrack] = []

    var body: some View {
        List {
            Section {
                Text("Last scrobbles").font(.headline).unredacted()
                if !scrobbles.isEmpty {
                    ForEach(scrobbles, id: \.name) {track in
                        NavigationLink(
                            destination: TrackView(track: Track(name: track.name, playcount: "0", listeners: "", url: "", artist: nil, image: track.image)),
                            label: {
                                ScrobbledTrackRow(track: track)
                            })
                    }
                } else {
                    // Placeholder for redacted
                    ForEach((1...5), id: \.self) {_ in
                        NavigationLink(
                            destination: Color(.red),
                            label: {
                                ScrobbledTrackRow(track: ScrobbledTrack(
                                    name: "toto",
                                    url: "123",
                                    image: [
                                        LastFMImage(
                                            url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp",
                                            size: "lol"
                                        ),
                                        LastFMImage(
                                            url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp",
                                            size: "lol"
                                        ),
                                        LastFMImage(
                                            url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp",
                                            size: "lol"
                                        ),
                                        LastFMImage(
                                            url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp",
                                            size: "lol"
                                        )
                                    ],
                                    artist: ScrobbledArtist(
                                        mbid: "",
                                        name: "Artist"
                                    ),
                                    date: nil
                                ))
                            })
                    }
                }
            }
        }
        .redacted(reason: scrobbles.isEmpty ? .placeholder : [])
    }
}
