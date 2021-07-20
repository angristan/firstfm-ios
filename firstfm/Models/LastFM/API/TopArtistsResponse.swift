struct TopArtistsResponse: Codable {
    var artists: ArtistsResponseContainer
}

struct ArtistsResponseContainer: Codable {
    var artist: [Artist]
}
