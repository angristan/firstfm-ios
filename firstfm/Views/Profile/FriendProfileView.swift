import SwiftUI
import Kingfisher

struct FriendProfileView: View {
    let friend: Friend
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var profile = ProfileViewModel()
    @State private var showingSettings = false
    @State private var showingFriends = false
    @State private var showingLovedTracks = false
    @State private var scrobblesPeriodPicked: Int = 5

    @ViewBuilder
    var body: some View {
        GeometryReader { g in
            ZStack {
                ZStack {
                    VStack {
                        ScrollView {
                            GeometryReader { geometry in
                                ZStack {
                                    if geometry.frame(in: .global).minY <= 0 {
                                        KFImage.url(URL(string: !self.profile.topArtists.isEmpty ? self.profile.topArtists[0].image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .overlay(TintOverlayView().opacity(0.3))
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .offset(y: geometry.frame(in: .global).minY / 9)
                                                .clipped()
                                    } else {
                                        KFImage.url(URL(string: !self.profile.topArtists.isEmpty ? self.profile.topArtists[0].image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .overlay(TintOverlayView().opacity(0.3))
                                                .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                                .clipped()
                                                .offset(y: -geometry.frame(in: .global).minY)
                                    }
                                }
                                        .redacted(reason: self.profile.topArtists.isEmpty ? .placeholder : [])
                            }
                                    .frame(height: 250)
                            VStack(alignment: .leading) {
                                HStack {
                                    KFImage.url(URL(string: profile.user?.image[3].url ?? "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 130, height: 130)
                                            .clipped()
                                            .cornerRadius(10)
                                            .padding(.trailing, 10)
                                    VStack(alignment: .leading) {

                                        Text("@\(friend.name)")
                                                .font(.custom("AvenirNext-Demibold", size: 20))

                                        Spacer()
                                        Text("Joined \(profile.user?.registered.getRelative() ?? "unkown time ago")")
                                                .font(.custom("AvenirNext-Regular", size: 16))
                                                .foregroundColor(.gray)
                                        Text("\(Int(profile.user?.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                                                .font(.custom("AvenirNext-Regular", size: 16))
                                                .foregroundColor(.gray)

                                    }
                                    Spacer()
                                }
                                        .offset(y: -65)
                            }
                                    .redacted(reason: profile.user == nil ? .placeholder : [])
                                    .frame(width: 350)

                            LastUserScrobblesView(scrobbles: profile.scrobbles)
                                    .frame(
                                            width: g.size.width - 5,
                                            height: g.size.height * 0.75,
                                            alignment: .center
                                    )
                                    .offset(y: -70)

                            TopUserArtistsView(artists: profile.topArtists)
                                    .environmentObject(profile)
                                    .offset(y: -100)

                            TopUserTracksView(tracks: profile.topTracks)
                                    .environmentObject(profile)
                                    .frame(
                                            width: g.size.width - 5,
                                            height: g.size.height * 0.75,
                                            alignment: .center
                                    )
                                    .offset(y: -100)

                            TopUserAlbumsView(albums: profile.topAlbums)
                                    .environmentObject(profile)
                                    .offset(y: -120)

                            if !profile.isFriendsLoading && !profile.friends.isEmpty {
                                UserFriendsHView()
                                        .environmentObject(profile)
                                        .offset(y: -120)
                            }

                        }
                                .padding(.bottom, -100)
                    }
                }
                        .onLoad {
                            self.profile.getAll(username: friend.name)
                        }
                        .navigationBarTitle("\(friend.name)'s profile", displayMode: .inline)

            }
        }
    }
}
