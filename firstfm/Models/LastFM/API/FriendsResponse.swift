import Foundation

struct FriendsResponse: Codable {
    let friends: Friends
}

struct Friends: Codable {
    let user: [Friend]
}
