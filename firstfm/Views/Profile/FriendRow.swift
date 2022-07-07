import SwiftUI
import Kingfisher

struct FriendRow: View {
    var friend: Friend

    var body: some View {
        HStack {
            if friend.image[2].url == "" {
                Image(systemName: "person.crop.circle")
                        .scaleEffect(2)
                        .frame(width: 50, height: 50)
            } else {
                KFImage.url(URL(string: friend.image[3].url)!)
                        .resizable()
                        .loadImmediately()
                        .onSuccess { res in
                            print("Success: \(self.friend.name) - \(res.cacheType)")
                        }
                        .onFailure { err in
                            print("Error \(self.friend.name): \(err)")
                        }
                        .fade(duration: 0.5)
                        .cancelOnDisappear(true)
                        .cornerRadius(5)
                        .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Spacer()
                Text(friend.name).font(.headline)
                        .lineLimit(1)
                Spacer()
                Text("Joined \(friend.registered.getRelative())")
                        .font(.subheadline)
                        .foregroundColor(.gray)
            }
        }
    }
}
