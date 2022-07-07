import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        ZStack {
            VStack {
                List(vm.friends) { friend in
                    NavigationLink(
                            destination: FriendProfileView(friend: friend),
                            label: {
                                FriendRow(friend: friend)
                            })
                }
                        .navigationBarTitle("Friends", displayMode: .inline)
                        .onLoad {
                            vm.getFriends(username: vm.user?.name ?? "")
                        }
            }

            if vm.friends.isEmpty {
                ProgressView().scaleEffect(2)
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
