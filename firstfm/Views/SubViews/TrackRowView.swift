import SwiftUI
import Kingfisher

struct TrackRow: View {
    var track: Track

    var body: some View {
        HStack {
            //            KFImage(URL(string: artist.image[0].url )!).resizable()
            //                .frame(width: 50, height: 50)
            KFImage.url(URL(string: track.image[0].url )!)
                .resizable()
                .loadImmediately()
                .onSuccess { res in
                    print("Success: \(self.track.name) - \(res.cacheType)")
                }
                .onFailure { err in
                    print("Error \(self.track.name): \(err)")
                }
//                .placeholder {
//                    ProgressView()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.gray)
//                }
                .fade(duration: 0.5)
                .cancelOnDisappear(true)
                .cornerRadius(5)
                .frame(width: 60, height: 60)
                .padding(.trailing, 5)

            VStack(alignment: .leading) {
                Spacer()
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(track.listeners )?.formatted() ?? "0") listeners")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
