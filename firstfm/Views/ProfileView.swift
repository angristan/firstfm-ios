//
//  ProfileView.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/06/2021.
//

import SwiftUI

struct ProfileView: View {
    
    let defaults = UserDefaults.standard
    
    @EnvironmentObject var auth: AuthViewModel
    
    
    @ViewBuilder
    var body: some View {
        ZStack {
            if auth.isLoggedIn {
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        defaults.removeObject(forKey: "lastfm_username")
                        auth.isLoggedIn = false
                    }) {
                        LogoutButton()
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

struct LogoutButton : View {
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
