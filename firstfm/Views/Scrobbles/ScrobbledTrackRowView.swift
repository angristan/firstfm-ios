import Kingfisher
import SwiftUI

struct ScrobbledTrackRow: View {
    @State var track: ScrobbledTrack
    @StateObject private var vm = ScrobbledTrackViewModel()

    private let imageSize: CGFloat = 60

    var body: some View {
        HStack {
            trackImage
            trackInfo
            loveButton
        }
    }

    private var trackImage: some View {
        KFImage.url(URL(string: track.image[3].url))
            .placeholder { ProgressView() }
            .resizable()
            .onSuccess { res in
                print("Success: \(self.track.name) - \(res.cacheType)")
            }
            .onFailure { err in
                print("Error \(self.track.name): \(err)")
            }
            .fade(duration: 0.5)
            .cancelOnDisappear(true)
            .cornerRadius(5)
            .frame(width: imageSize, height: imageSize)
            .padding(.trailing, 5)
    }

    private var trackInfo: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(track.name)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
            Spacer()
            HStack {
                Text(track.artist.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
                Text(track.date?.getRelative() ?? "Now Playing")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(alignment: .leading)
                    .lineLimit(1)
            }
            Spacer()
        }
    }

    private var loveButton: some View {
        Button(action: {
            if track.loved == "0" {
                track.loved = "1"
                vm.loveTrack(track: track)
            } else {
                track.loved = "0"
                vm.unloveTrack(track: track)
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            Image(systemName: track.loved == "1" ? "heart.fill" : "heart")
                .imageScale(.large)
                .foregroundColor(track.loved == "1" ? Color(red: 157/255, green: 0, blue: 0) : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
