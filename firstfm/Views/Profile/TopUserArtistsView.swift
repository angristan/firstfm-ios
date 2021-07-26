import SwiftUI
import Kingfisher

struct TopUserArtistsView: View {
    var artists: [Artist]
//    @State private var scrobblesPeriodPicked: Int = 5
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        Section {
            HStack {
                Text("Top artists").font(.headline)
                Spacer()

                Menu {
                    Picker(selection: $vm.scrobblesPeriodPicked, label: Text("Period")) {
                        Text("Last 7 days").tag(0)
                        Text("Last 30 days").tag(1)
                        Text("Last 90 days").tag(2)
                        Text("Last 180 days").tag(3)
                        Text("Last 365 days").tag(4)
                        Text("All time").tag(5)
                    }.onChange(of: vm.scrobblesPeriodPicked) {
                        tag in vm.getTopArtistsForPeriodTag(username: vm.user?.name ?? "", tag: tag)
                    }
                }
            label: {
                Label("", systemImage: "calendar").foregroundColor(.white)
            }
            }.unredacted()
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 50, maximum: 200)),
                GridItem(.flexible(minimum: 50, maximum: 200))
            ], spacing: 30 ) {
                if !artists.isEmpty {
                    ForEach(artists, id: \.name) { artist in
                        NavigationLink(
                            destination: ArtistView(artist: artist),
                            label: {
                                VStack {
                                    KFImage.url(URL(string: artist.image[0].url != "" ? artist.image[0].url : "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                        .resizable()
                                        .loadImmediately()
                                        .fade(duration: 0.5)
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                    Text(artist.name).font(.headline).lineLimit(1).foregroundColor(.white)
                                    Text("\(Int(artist.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                                        .font(.subheadline)
                                        .foregroundColor(.gray).lineLimit(1)
                                }
                            })

                    }
                } else {
                    // Placeholder for redacted
                    ForEach((1...6), id: \.self) {_ in
                        NavigationLink(
                            destination: Color(.red),
                            label: {
                                VStack {
                                    KFImage.url(URL(string: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                        .resizable()
                                        .loadImmediately()
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                    Text("Album name").font(.headline).lineLimit(1).foregroundColor(.white)
                                    Text("\(String(format: "%ld", locale: Locale.current, 0) ) listeners")
                                        .font(.subheadline)
                                        .foregroundColor(.gray).lineLimit(1)
                                }
                            })
                    }

                }
            }
        }.padding()
        .redacted(reason: artists.isEmpty ? .placeholder : [])
    }
}
