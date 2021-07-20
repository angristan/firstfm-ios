import Foundation

// MARK: - FriendsResponse
struct FriendsResponse: Codable {
    let friends: Friends
}

// MARK: - Friends
struct Friends: Codable {
    let user: [Friend]
}
