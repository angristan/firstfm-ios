import SwiftUI
import Kingfisher

struct AlbumView: View {
    var album: ArtistAlbum

    var body: some View {
        GeometryReader { _ in
                ScrollView {
                    GeometryReader { geometry in
                        ZStack {
                            if geometry.frame(in: .global).minY <= 0 {
                                KFImage.url(URL(string: !self.album.image.isEmpty ? self.album.image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .loadImmediately()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(TintOverlayView().opacity(0.2))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .offset(y: geometry.frame(in: .global).minY/9)
                                    .clipped()
                            } else {
                                KFImage.url(URL(string: !self.album.image.isEmpty ? self.album.image[0].url : "https://www.nme.com/wp-content/uploads/2021/04/twice-betterconceptphoto-2020.jpg")!)
                                    .resizable()
                                    .loadImmediately()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(TintOverlayView().opacity(0.2))
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                            }
                        }
                    }.frame(height: 300)

                    HStack {
                        VStack {
                            Text("Scrobbles")
                            Text("50k")
                        }
                        VStack {
                            Text("Listeners")
                            Text("52k")
                        }
                    }.offset(y: -50)
                    HStack {
                        Text("tag")
                        Text("tag")
                        Text("tag")
                        Text("tag")
                    }
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                    Divider()
                    Text("[img] Artist ->")
                    Divider()
                    Text("Tracklist")
                    Text("1 Rolling")
                    Text("2 Memory")
                }
            }

    }
}
