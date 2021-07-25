import SwiftUI

struct ArtistInfoView: View {

    var artistInfo: ArtistInfo?
    var artist: Artist

    var body: some View {
        HStack {
            Text("\(artistInfo?.stats.playcount.formatted() ?? "0") scrobbles")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(artistInfo?.stats.listeners.formatted() ?? "0") listeners")
                .font(.subheadline)
                .foregroundColor(.gray)
        }

        NavigationLink(destination: ArtistBioView(artistInfo: artistInfo)) {
            VStack(alignment: .leading) {
                Text(artistInfo?.bio.content ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }
        }

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let artistInfo = artistInfo {
                    ForEach(artistInfo.tags.tag, id: \.name) {tag in
                        NavigationLink(
                            destination: TagView(tag: tag),
                            label: {
                            Text(tag.name)
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(.infinity)
                                .lineLimit(1)
                        })

                    }
                } else {
                    // Placeholder for redacted
                    ForEach(["pop", "synthpop", "female vocalist", "indie"], id: \.self) {tag in
                        Text(tag)
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
