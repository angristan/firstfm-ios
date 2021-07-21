import SwiftUI

struct ArtistInfoView: View {

    var artistInfo: ArtistInfo?
    var artist: Artist

    var body: some View {
        HStack {
            Text("\(Int(artist.playcount ?? "0")?.formatted() ?? "0") scrobbles")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(Int(artist.listeners)?.formatted() ?? "0") listeners")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        Text(artistInfo?.bio.content ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.").lineLimit(3)

        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                if let artistInfo = artistInfo {
                    ForEach(artistInfo.tags.tag, id: \.name) {tag in
                        Button(action: {}) {
                            HStack {
                                Text(tag.name)
                            }
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                        .lineLimit(1)
                    }
                } else {
                    // Placeholder for redacted
                    ForEach(["pop", "synthpop", "female vocalist", "indie"], id: \.self) {tag in
                        Button(action: {}) {
                            HStack {
                                Text(tag)
                            }
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                        .lineLimit(1)
                    }
                }
            }
        }
    }
}
