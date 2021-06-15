//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import SwiftUI
import Kingfisher

struct TrackRow: View {
    var track: Track

    var body: some View {
        HStack() {
            //            KFImage(URL(string: artist.image[0].url )!).resizable()
            //                .frame(width: 50, height: 50)
            KFImage.url(URL(string: track.image[0].url )!)
                .resizable()
                .onSuccess { r in
                    print("Success: \(self.track.name) - \(r.cacheType)")
                }
                .onFailure { e in
                    print("Error \(self.track.name): \(e)")
                }
//                .placeholder {
//                    ProgressView()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.gray)
//                }
                .fade(duration: 1)
                .cancelOnDisappear(true)
                .cornerRadius(5)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Spacer()
                Text(track.name).font(.headline)
                Spacer()
                Text("\(String(format: "%ld", locale: Locale.current, (track.listeners as NSString).integerValue) ) listeners")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
