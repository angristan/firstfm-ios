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
        HStack() {
            //            KFImage(URL(string: artist.image[0].url )!).resizable()
            //                .frame(width: 50, height: 50)
            KFImage.url(URL(string: artist.image[0].url )!)
                .resizable()
                .onSuccess { r in
                    print("Success: \(self.artist.name) - \(r.cacheType)")
                }
                .onFailure { e in
                    print("Error \(self.artist): \(e)")
                }
                .placeholder {
                    HStack {
                        Image(systemName: "arrow.2.circlepath.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                        Text("Loading...").font(.title)
                    }
                    .foregroundColor(.gray)
                }
                .fade(duration: 5)
                .cancelOnDisappear(true)
                .cornerRadius(5)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Spacer()
                Text(artist.name).font(.headline)
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
