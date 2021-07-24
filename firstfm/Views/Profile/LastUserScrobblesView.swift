import SwiftUI

struct LastUserScrobblesView: View {

    var scrobbles: [ScrobbledTrack] = []

    var body: some View {
        List {
            Section {
                Text("Last scrobbles").font(.headline).unredacted()
                if !scrobbles.isEmpty {
                    // Why 0 to 4? Because even if we ask the last.fm API for n tracks,
                    // it will return n tracks OR n tracks + now playing track :|
                    // Since it messes with the layout we query the API for 5 (+1) tracks
                    // and display at most 5.
                    ForEach((0...4), id: \.self) {i in
                        NavigationLink(
                            destination: TrackView(track: Track(name: scrobbles[i].name, playcount: "0", listeners: "", url: "", artist: nil, image: scrobbles[i].image)),
                            label: {
                                ScrobbledTrackRow(track: scrobbles[i])
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
        }.hasScrollEnabled(false)
        .redacted(reason: scrobbles.isEmpty ? .placeholder : [])
    }
}
