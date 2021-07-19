//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI
import Kingfisher

struct ArtistRow: View {
    var artist: Artist

    var body: some View {
        HStack {
            //            KFImage(URL(string: artist.image[0].url )!).resizable()
            //                .frame(width: 50, height: 50)
            KFImage.url(URL(string: artist.image[0].url )!)
                .resizable()
                .loadImmediately()
                .onSuccess { res in
                    print("Success: \(self.artist.name) - \(res.cacheType)")
                }
                .onFailure { err in
                    print("Error \(self.artist): \(err)")
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
                Text("\(String(format: "%ld", locale: Locale.current, (artist.listeners as NSString).integerValue) ) listeners")
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
