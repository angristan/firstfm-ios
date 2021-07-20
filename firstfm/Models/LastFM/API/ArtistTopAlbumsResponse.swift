struct ArtistTopAlbumsResponse: Codable {
    var topalbums: ArtistTopAlbumsResponseTopAlbumsContainer
}

struct ArtistTopAlbumsResponseTopAlbumsContainer: Codable {
    var album: [ArtistAlbum]
}
