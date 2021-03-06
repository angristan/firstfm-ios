import SwiftUI
import Kingfisher

struct ScrobbledTrackRow: View {
    @State var track: ScrobbledTrack
    var vm = ScrobbledTrackViewModel()

    var body: some View {
        HStack {
            KFImage.url(URL(string: track.image[3].url)!)
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
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 5)

            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(track.name)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                }
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
            Button(action: {
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                if self.track.loved == "0" {
                    self.track.loved = "1"
                    vm.loveTrack(track: self.track)
                } else {
                    self.track.loved = "0"
                    vm.unloveTrack(track: self.track)
                }
                hapticFeedback.impactOccurred()
            }) {
                if self.track.loved == "1" {
                    Image(systemName: "heart.fill").imageScale(.large).foregroundColor(Color(red: 157, green: 0, blue: 0))
                } else {
                    Image(systemName: "heart").imageScale(.large)
                }
            }
                    .buttonStyle(PlainButtonStyle())
        }
    }
}
