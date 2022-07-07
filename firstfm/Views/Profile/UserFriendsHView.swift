import SwiftUI
import Kingfisher

struct UserFriendsHView: View {
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        Section {
            HStack {
                Text("Friends").font(.headline).unredacted()
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if !vm.friends.isEmpty {
                        ForEach(vm.friends, id: \.name) { friend in
                            ZStack {
                                Button("") {
                                }
                                NavigationLink(
                                        destination: FriendProfileView(friend: friend),
                                        label: {
                                            VStack {
                                                if friend.image[3].url == "" {
                                                    KFImage.url(URL(string: "https://bonds-and-shares.com/wp-content/uploads/2019/07/placeholder-user.png")!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .cornerRadius(.infinity)
                                                } else {
                                                    KFImage.url(URL(string: friend.image[3].url)!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .cornerRadius(.infinity)
                                                }

                                                Text(friend.name).font(.subheadline)
                                                        .foregroundColor(.gray).lineLimit(1)
                                            }
                                                    .padding(.horizontal, 10)
                                        })
                            }

                        }
                    } else {
                        // Placeholder for redacted
                        ForEach((1...5), id: \.self) { _ in
                            VStack {
                                KFImage.url(URL(string: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .cornerRadius(.infinity)

                                Text("Friend").font(.subheadline)
                                        .foregroundColor(.gray).lineLimit(1)
                            }
                        }
                    }
                }
            }
        }
                .padding()
    }
}
