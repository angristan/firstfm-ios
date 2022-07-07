import SwiftUI
import Kingfisher
import os

struct ArtistRow: View {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: ArtistRow.self)
    )
    var artist: Artist

    var body: some View {
        HStack {
            //            KFImage(URL(string: artist.image[0].url )!).resizable()
            //                .frame(width: 50, height: 50)
            KFImage.url(URL(string: artist.image[0].url)!)
                    .resizable()
                    .onSuccess { _ in
                        ArtistRow.logger.log("Successfully loaded image for artist \(artist.name)")
                    }
                    .onFailure { err in
                        ArtistRow.logger.error("Error while loading image for artist \(artist.name): \(err.localizedDescription, privacy: .public)")
                    }
                    //                .placeholder {
                    //                    ProgressView()
                    //                        .frame(width: 50, height: 50)
                    //                        .foregroundColor(.gray)
                    //                }
                    .fade(duration: 0.5)
                    .cancelOnDisappear(true)
                    .cornerRadius(5)
                    .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Spacer()
                Text(artist.name).font(.headline)
                        .lineLimit(1)
                Spacer()
                Text("\(Int(artist.listeners ?? "0")?.formatted() ?? "0") listeners")
                        .font(.subheadline)
                        .foregroundColor(.gray)
            }
        }
    }
}

struct ArtistRow_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            ChartList()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
        }
    }
}
