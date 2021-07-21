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
        ZStack {
            if auth.isLoggedIn() {
                NavigationView {
                    ZStack {
                        VStack {
                            if let user = profile.user {
                                ScrollView {
                                    GeometryReader { geometry in
                                        ZStack {
                                            if geometry.frame(in: .global).minY <= 0 {
                                                KFImage.url(URL(string: "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg" )!)
                                                    .resizable()
                                                    .loadImmediately()
                                                    .aspectRatio(contentMode: .fill)
                                                    .overlay(TintOverlayView().opacity(0.2))
                                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                                    .offset(y: geometry.frame(in: .global).minY/9)
                                                    .clipped()
                                                    .blur(radius: 5)
                                            } else {
                                                KFImage.url(URL(string: "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg" )!)
                                                    .resizable()
                                                    .loadImmediately()
                                                    .aspectRatio(contentMode: .fill)
                                                    .overlay(TintOverlayView().opacity(0.2))
                                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                                    .clipped()
                                                    .offset(y: -geometry.frame(in: .global).minY)
                                                    .blur(radius: 5)
                                            }
                                        }
                                    }
                                    .frame(height: 250)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            KFImage.url(URL(string: user.image[3].url )!)
                                                .resizable()
                                                .loadImmediately()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 120)
                                                .clipped()
                                                .cornerRadius(10)
                                                .padding(.trailing, 10)
                                            VStack(alignment: .leading) {

                                                Text("@\(storedUsername ?? "username")")
                                                    .font(.custom("AvenirNext-Demibold", size: 18))

                                                Spacer()
                                                Text("Joined \(user.registered.getRelative())")
                                                    .font(.custom("AvenirNext-Regular", size: 15))
                                                    .foregroundColor(.gray)
                                                Text("\(Int(user.playcount)?.formatted() ?? "0") scrobbles")
                                                    .font(.custom("AvenirNext-Regular", size: 15))
                                                    .foregroundColor(.gray)

                                            }
                                            Spacer()
                                        }
                                        .offset(y: -50)
                                    }
                                    .frame(width: 350)
                                }
                                .edgesIgnoringSafeArea(.top)
                            }
                        }.edgesIgnoringSafeArea(.top)
                            .navigationBarTitle("")
                        // Show loader above the rest of the ZStack
                        if profile.isLoading {
                            ProgressView().scaleEffect(2)
                        }
                    }.onAppear {
                        if let username = storedUsername {
                            self.profile.getProfile(username: username)
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
                                    profile.getFriends(username: storedUsername)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
