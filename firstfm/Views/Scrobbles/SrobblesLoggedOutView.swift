import SwiftUI

struct SrobblesLoggedOutView: View {
    var body: some View {
        GeometryReader { _ in
            ZStack {
                List {
                    ForEach((1...10), id: \.self) { _ in
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
                            .navigationTitle("Your scrobbles")
                            .redacted(reason: .placeholder)
                }
                        .offset(y: 30)
                        .overlay(TintOverlayView().opacity(0.2))
                        .blur(radius: 3)

                LoginGuardView()
                        //                    .offset(y: 200)
                        .tabItem {
                            Text("Profile")
                            Image(systemName: "person.crop.circle")
                        }
            }
        }
    }
}
