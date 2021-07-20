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
                ForEach(albums, id: \.name) { album in
                    NavigationLink(
                        destination: Color(.red),
                        label: {
                        VStack {
                            KFImage.url(URL(string: album.image[0].url )!)
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
            }
        }.padding()
    }
}
