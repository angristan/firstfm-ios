//
//  ProfileView.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/06/2021.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("lastfm_username") var storedUsername: String?
    @ObservedObject var profile = ProfileViewModel()
    @State private var showingSettings = false
    @State private var showingFriends = false

    @ViewBuilder
    var body: some View {
        ZStack {
            if auth.isLoggedIn() {
                NavigationView {
                    ZStack {
                        VStack {
                            if let user = profile.user {
                                KFImage.url(URL(string: user.image[3].url )!)
                                    .resizable()
                                    .onSuccess { res in
                                        print("Success: \(user.name) - \(res.cacheType)")
                                    }
                                    .onFailure { err in
                                        print("Error \(user.name): \(err)")
                                    }
                                    .fade(duration: 1)
                                    .cancelOnDisappear(true)
                                    .cornerRadius(5)
                                    .frame(width: 200, height: 200)
                                Text("Hello, \(user.name)")
                                Text("Playcount: \(user.playcount)")
                                Button(action: {
                                    storedUsername = nil
                                }) {
                                    LogoutButton()
                                }
                            }
                        }
                        // Show loader above the rest of the ZStack
                        if profile.isLoading {
                            ProgressView()
                        }
                    }.onAppear {
                        if let username = storedUsername {
                            self.profile.getProfile(username: username)
                        }
                    }.navigationTitle("Your profile")
                        .navigationBarItems(trailing: HStack {
                            Button(action: {
                                showingSettings.toggle()
                            }) {
                                Image(systemName: "gear").imageScale(.large)
                            }

                            Button(action: {
                                if let storedUsername = storedUsername {
                                    profile.getFriends(username: storedUsername)
                                    showingFriends.toggle()
                                }
                            }) {
                                Image(systemName: "person.2").imageScale(.large)
                            }
                        }
                        )
                        .sheet(isPresented: $showingSettings) {
                            Text("Here settings aka logout button")
                        }
                        .sheet(isPresented: $showingFriends) {
                            FriendsView().environmentObject(profile)
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

struct LogoutButton: View {
    var body: some View {
        return Text("Logout")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 100, height: 60)
            .background(Color(red: 185 / 255, green: 0 / 255, blue: 0 / 255))
            .cornerRadius(15.0)
    }
}
