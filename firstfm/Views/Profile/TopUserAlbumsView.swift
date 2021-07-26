import SwiftUI
import Kingfisher

struct TopUserAlbumsView: View {
    var albums: [TopAlbum]
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        Section {
            HStack {
                Text("Top albums").font(.headline)
                Spacer()

                Menu {
                    Picker(selection: $vm.topAlbumsPeriodPicked, label: Text("Period")) {
                        Text("Last 7 days").tag(0)
                        Text("Last 30 days").tag(1)
                        Text("Last 90 days").tag(2)
                        Text("Last 180 days").tag(3)
                        Text("Last 365 days").tag(4)
                        Text("All time").tag(5)
                    }.onChange(of: vm.topAlbumsPeriodPicked) {
                        tag in vm.getTopAlbumsForPeriodTag(username: vm.user?.name ?? "", tag: tag)
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
                if !albums.isEmpty {
                    ForEach(albums, id: \.name) { album in
                        NavigationLink(
                            destination: AlbumView(album: ArtistAlbum(mbid: album.mbid, name: album.name, playcount: UInt(album.playcount) ?? 0, url: album.url, image: album.image )),
                            label: {
                            VStack {
                                if let image = album.image {
                                    KFImage.url(URL(string: image[0].url != "" ? image[0].url : "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                        .resizable()
                                        .loadImmediately()
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    KFImage.url(URL(string: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                        .resizable()
                                        .loadImmediately()
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                }

                                Text(album.name).font(.headline).lineLimit(1).foregroundColor(.white)
                                Text("\(Int(album.playcount)?.formatted() ?? "0") scrobbles")
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
            .redacted(reason: albums.isEmpty ? .placeholder : [])
    }
}
