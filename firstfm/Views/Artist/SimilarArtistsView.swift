import SwiftUI
import Kingfisher

struct SimilarArtistsView: View {
    var similarArtists: [SimilarArtist]

    var body: some View {
        VStack {
            Section {
                Text("Similar artists").font(.headline).unredacted()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if !similarArtists.isEmpty {
                            ForEach(similarArtists, id: \.name) { artist in
                                ZStack {
                                    Button("") {
                                    }
                                    NavigationLink(
                                            destination: ArtistView(artist: Artist(mbid: "", name: artist.name, playcount: "0", listeners: "0", image: artist.image)),
                                            label: {
                                                VStack {
                                                    KFImage.url(URL(string: artist.image[0].url)!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 150, height: 150)
                                                            .clipShape(Circle())
                                                            .cornerRadius(.infinity)

                                                    Text(artist.name).font(.subheadline)
                                                            .foregroundColor(.gray).lineLimit(1)
                                                }

                                            })
                                }

                            }
                        } else {
                            // Placeholder for redacted
                            ForEach((1...5), id: \.self) { _ in
                                VStack {
                                    KFImage.url(URL(string: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                            .cornerRadius(.infinity)

                                    Text("Artist").font(.subheadline)
                                            .foregroundColor(.gray).lineLimit(1)
                                }
                                        .padding(.trailing, 5.0)
                            }
                        }
                    }
                }
            }
                    .padding()
        }
    }
}

struct SimilarArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        let similarArtists: [SimilarArtist] = SimilarArtists.fixture().artist

        return Group {
            SimilarArtistsView(similarArtists: similarArtists).previewDevice("iPhone 12")
            SimilarArtistsView(similarArtists: []).previewDevice("iPhone 12")
        }
    }
}
