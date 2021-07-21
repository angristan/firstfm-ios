import SwiftUI
import Kingfisher

struct TopArtistAlbumsView: View {
    var albums: [ArtistAlbum]

    var body: some View {
        Section {
            Text("Top albums").font(.headline)
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 50, maximum: 200)),
                GridItem(.flexible(minimum: 50, maximum: 200))
            ], spacing: 30 ) {
                if !albums.isEmpty {
                    ForEach(albums, id: \.name) { album in
                        NavigationLink(
                            destination: AlbumView(album: album),
                            label: {
                            VStack {
                                KFImage.url(URL(string: album.image[0].url != "" ? album.image[0].url : "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                    .resizable()
                                    .loadImmediately()
                                    .cornerRadius(5)
                                    .aspectRatio(contentMode: .fill)
                                Text(album.name).font(.headline).lineLimit(1).foregroundColor(.white)
                                Text("\(String(format: "%ld", locale: Locale.current, album.playcount) ) listeners")
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
    }
}
