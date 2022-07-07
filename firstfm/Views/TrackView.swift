import SwiftUI
import Kingfisher

struct TrackView: View {
    //    @ObservedObject private var vm = TrackViewModel()
    var track: Track

    var body: some View {
        GeometryReader { _ in
            ScrollView {
                GeometryReader { geometry in
                    ZStack {
                        if geometry.frame(in: .global).minY <= 0 {
                            KFImage.url(URL(string: !self.track.image.isEmpty ? self.track.image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(TintOverlayView().opacity(0.2))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .offset(y: geometry.frame(in: .global).minY / 9)
                                    .clipped()
                        } else {
                            KFImage.url(URL(string: !self.track.image.isEmpty ? self.track.image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(TintOverlayView().opacity(0.2))
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                        }
                    }
                }
                        .frame(height: 200)

                HStack {
                    VStack {
                        Text("Scrobbles")
                        Text("50k")
                    }
                    VStack {
                        Text("Listeners")
                        Text("52k")
                    }
                    Image(systemName: "heart")
                }
                Divider()
                HStack {
                    Text("tag")
                    Text("tag")
                    Text("tag")
                    Text("tag")
                }
                Divider()
                Text("[img] Artist ->")
                Divider()
                Text("From the album")
                Text("[img] Album ->")
            }
        }

    }
}
