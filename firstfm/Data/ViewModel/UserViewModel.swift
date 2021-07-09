//
//  UserViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 06/07/2021.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    var isLoading = true

    func getProfile(username: String) {
        self.isLoading = true
        
        LastFMAPI.request(lastFMMethod: "user.getInfo", args: ["user": username]) { (data: UserInfoResponse?, error) -> Void in
            self.isLoading = false
            
            if let data = data {
                DispatchQueue.main.async {
                    self.user = data.user
                }
            }
        }
    }
}
