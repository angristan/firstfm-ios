import Foundation

struct SimilarArtist: Codable {
    let url: String
    let name: String
    var image: [LastFMImage]
}

struct SimilarArtists: Codable {
    var artist: [SimilarArtist]
}

extension SimilarArtist {
    static func fixture(
            url: String = "https://last.fm",
            name: String = "Red Velvet",
            image: [LastFMImage] = [.fixture()]
    ) -> SimilarArtist {
        SimilarArtist(
                url: url,
                name: name,
                image: image)
    }
}

extension SimilarArtists {
    static func fixture(
            artists: [SimilarArtist] = [
                .fixture(),
                .fixture(),
                .fixture(),
                .fixture(),
                .fixture()
            ]
    ) -> SimilarArtists {
        SimilarArtists(
                artist: artists
        )
    }
}
