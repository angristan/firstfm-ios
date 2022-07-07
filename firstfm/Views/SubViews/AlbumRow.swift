import SwiftUI
import Kingfisher

struct AlbumRow: View {
    var album: ArtistAlbum

    var body: some View {
        HStack {
            KFImage.url(URL(string: album.image[0].url))
                    .resizable()
                    .onSuccess { res in
                        print("Success: \(self.album.name) - \(res.cacheType)")
                    }
                    .onFailure { err in
                        print("Error \(self.album): \(err)")
                    }
                    .fade(duration: 0.5)
                    .cancelOnDisappear(true)
                    .cornerRadius(5)
                    .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Spacer()
                Text(album.name).font(.headline)
                        .lineLimit(1)
                Spacer()
                Text("\(String(format: "%ld", locale: Locale.current, album.playcount)) listeners")
                        .font(.subheadline)
                        .foregroundColor(.gray)
            }
        }
    }
}

struct AlbumRow_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            ChartList()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
        }
    }
}
