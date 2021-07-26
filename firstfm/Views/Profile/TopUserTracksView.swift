import SwiftUI

struct TopUserTracksView: View {
    var tracks: [Track]
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Top tracks").font(.headline)
                    Spacer()

                    Menu {
                        Picker(selection: $vm.topTracksPeriodPicked, label: Text("Period")) {
                            Text("Last 7 days").tag(0)
                            Text("Last 30 days").tag(1)
                            Text("Last 90 days").tag(2)
                            Text("Last 180 days").tag(3)
                            Text("Last 365 days").tag(4)
                            Text("All time").tag(5)
                        }.onChange(of: vm.topTracksPeriodPicked) {
                            tag in vm.getTopTracksForPeriodTag(tag: tag)
                        }
                    }
                label: {
                    Label("", systemImage: "calendar").foregroundColor(.white)
                }
                }.unredacted()
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
            .redacted(reason: tracks.isEmpty ? .placeholder : [])
    }
}
