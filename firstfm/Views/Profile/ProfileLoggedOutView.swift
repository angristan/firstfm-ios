import SwiftUI
import Kingfisher

struct ProfileLoggedOutView: View {

    var body: some View {
        GeometryReader { g in
            ZStack {
                ScrollView {
                    GeometryReader { geometry in
                        ZStack {
                            KFImage.url(URL(string: "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(TintOverlayView().opacity(0.2))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .offset(y: geometry.frame(in: .global).minY / 9)
                                    .clipped()
                                    .blur(radius: 3)
                        }
                                .redacted(reason: .placeholder)
                    }
                            .frame(height: 250)
                    VStack(alignment: .leading) {
                        HStack {
                            KFImage.url(URL(string: "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.trailing, 10).redacted(reason: .placeholder)
                            VStack(alignment: .leading) {
                                Text("@username")
                                        .font(.custom("AvenirNext-Demibold", size: 18))
                                Spacer()
                                Text("Joined unknown time ago")
                                        .font(.custom("AvenirNext-Regular", size: 15))
                                        .foregroundColor(.gray)
                                Text("123 scrobbles")
                                        .font(.custom("AvenirNext-Regular", size: 15))
                                        .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                                .offset(y: -65)
                    }
                            .redacted(reason: .placeholder)
                            .frame(width: 350)
                    List {
                        Section {
                            Text("Last scrobbles").font(.headline).unredacted()
                            ForEach((1...5), id: \.self) { _ in
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
                            .redacted(reason: .placeholder)
                            .frame(
                                    width: g.size.width - 5,
                                    height: g.size.height * 0.7,
                                    alignment: .center
                            )
                            .offset(y: -70)
                }
                        .edgesIgnoringSafeArea(.top)
                        .overlay(TintOverlayView().opacity(0.2))
                        .frame(width: g.size.width, height: g.size.height + g.frame(in: .global).minY)
                        .blur(radius: 3)

                LoginGuardView()
                        .offset(y: 100)
                        .tabItem {
                            Text("Profile")
                            Image(systemName: "person.crop.circle")
                        }

            }
        }
    }
}
