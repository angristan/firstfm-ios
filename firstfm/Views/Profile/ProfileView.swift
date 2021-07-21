import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("lastfm_username") var storedUsername: String?
    @ObservedObject var profile = ProfileViewModel()
    @State private var showingSettings = false
    @State private var showingFriends = false
    @State private var showingLovedTracks = false

    @ViewBuilder
    var body: some View {
        GeometryReader { g in
            ZStack {
                if auth.isLoggedIn() {
                    NavigationView {
                        ZStack {
                            VStack {
                                ScrollView {
                                    GeometryReader { geometry in
                                        ZStack {
                                            if geometry.frame(in: .global).minY <= 0 {
                                                KFImage.url(URL(string: !self.profile.topArtists.isEmpty ? self.profile.topArtists[0].image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg" )!)
                                                    .resizable()
                                                    .loadImmediately()
                                                    .aspectRatio(contentMode: .fill)
                                                    .overlay(TintOverlayView().opacity(0.2))
                                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                                    .offset(y: geometry.frame(in: .global).minY/9)
                                                    .clipped()
                                                    .blur(radius: 3)
                                            } else {
                                                KFImage.url(URL(string: !self.profile.topArtists.isEmpty ? self.profile.topArtists[0].image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg" )!)
                                                    .resizable()
                                                    .loadImmediately()
                                                    .aspectRatio(contentMode: .fill)
                                                    .overlay(TintOverlayView().opacity(0.2))
                                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                                    .clipped()
                                                    .offset(y: -geometry.frame(in: .global).minY)
                                                    .blur(radius: 3)
                                            }
                                        } .redacted(reason: self.profile.topArtists.isEmpty ? .placeholder : [])
                                    }
                                    .frame(height: 250)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            KFImage.url(URL(string: profile.user?.image[3].url ?? "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp" )!)
                                                .resizable()
                                                .loadImmediately()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 130, height: 130)
                                                .clipped()
                                                .cornerRadius(10)
                                                .padding(.trailing, 10)
                                            VStack(alignment: .leading) {

                                                Text("@\(storedUsername ?? "username")")
                                                    .font(.custom("AvenirNext-Demibold", size: 18))

                                                Spacer()
                                                Text("Joined \(profile.user?.registered.getRelative() ?? "unkown time ago")")
                                                    .font(.custom("AvenirNext-Regular", size: 15))
                                                    .foregroundColor(.gray)
                                                Text("\(Int(profile.user?.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                                                    .font(.custom("AvenirNext-Regular", size: 15))
                                                    .foregroundColor(.gray)

                                            }
                                            Spacer()
                                        }
                                        .offset(y: -65)
                                    }
                                    .redacted(reason: profile.user == nil ? .placeholder : [])
                                    .frame(width: 350)
                                    List {
                                        Section {
                                            Text("Last scrobbles").font(.headline).unredacted()
                                            if !profile.scrobbles.isEmpty {
                                                ForEach(profile.scrobbles, id: \.name) {track in
                                                    NavigationLink(
                                                        destination: Color(.blue),
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
                                    .redacted(reason: profile.scrobbles.isEmpty ? .placeholder : [])
                                    .frame(
                                        width: g.size.width - 5,
                                        height: g.size.height * 0.7,
                                        alignment: .center
                                    )
                                    .offset(y: -70)
                                }
                                .edgesIgnoringSafeArea(.top)
                            }.edgesIgnoringSafeArea(.top)
                                .navigationBarTitle("")
                        }
                        .onAppear {
                            if let username = storedUsername {
                                self.profile.getAll(username)
                            }
                        }.navigationTitle("Your profile")
                            .navigationBarItems(trailing: HStack {
                                Button(action: {
                                    if let storedUsername = storedUsername {
                                        // getlovedtracks
                                        showingLovedTracks.toggle()
                                    }
                                }) {
                                    Image(systemName: "heart").imageScale(.large).foregroundColor(.white)
                                }
                                Button(action: {
                                    if let storedUsername = storedUsername {
                                        profile.getFriends(storedUsername)
                                        showingFriends.toggle()
                                    }
                                }) {
                                    Image(systemName: "person.2").imageScale(.large).foregroundColor(.white)
                                }
                                Button(action: {
                                    showingSettings.toggle()
                                }) {
                                    Image(systemName: "gear").imageScale(.large).foregroundColor(.white)
                                }
                            }
                            )
                            .sheet(isPresented: $showingSettings) {
                                Text("Here settings aka logout button")
                                Button(action: {
                                    storedUsername = nil
                                }) {
                                    LogoutButton()
                                }
                            }
                            .sheet(isPresented: $showingFriends) {
                                FriendsView().environmentObject(profile)
                            }
                            .sheet(isPresented: $showingLovedTracks) {
                                Text("Here be loved tracks")
                            }
                    }
                } else {
                    LoginGuardView()
                        .tabItem {
                            Text("Profile")
                            Image(systemName: "person.crop.circle")
                        }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
