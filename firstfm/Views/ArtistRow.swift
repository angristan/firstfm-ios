/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A single row to be displayed in a list of landmarks.
 */

import SwiftUI

struct ArtistRow: View {
    var artist: Artist


    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: "https://lastfm.freetls.fastly.net/i/u/770x0/f87e3e186c83d808d7e40c0f608ff50d.webp#f87e3e186c83d808d7e40c0f608ff50d")!,
                placeholder: { Text("Loading ...") },
                image: { Image(uiImage: $0).resizable() }
            )
            .frame(width: 50, height: 50)
            Text(artist.name)

            Spacer()
        }
    }
}

//struct ArtistRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 12"], id: \.self) { deviceName in
//            ArtistRow(artist: <#Artist#>)
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
//    }
//}
