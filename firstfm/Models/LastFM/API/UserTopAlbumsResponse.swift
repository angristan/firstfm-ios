struct UserTopAlbumsResponse: Codable {
    var topalbums: UserTopAlbums
}

struct UserTopAlbums: Codable {
    var album: [TopAlbum]
}
