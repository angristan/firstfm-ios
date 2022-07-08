import SwiftUI

struct ArtistBioView: View {
    var artistInfo: ArtistInfo?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(artistInfo?.bio.content ?? "There is no bio for this artist")
                        .padding()
                        .navigationTitle("\(artistInfo?.name ?? "Artist") bio")
                        .navigationBarItems(trailing: HStack {
                            if let link = artistInfo?.bio.links.link.href {

                                Link(destination: URL(string: link)!) {
                                    Image(systemName: "link.circle.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                }
                            }
                        })
                        .textSelection(.enabled)
            }
        }
    }
}
