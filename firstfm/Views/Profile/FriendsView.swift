import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var vm: ProfileViewModel

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List(vm.friends) { friend in
                        NavigationLink(
                            destination: Color(.blue),
                            label: {
                            FriendRow(friend: friend)
                        })
                    }.navigationTitle("Friends").onAppear {
                        vm.getFriends(vm.user?.name ?? "")
                    }
                }

                if vm.isFriendsLoading {
                    ProgressView().scaleEffect(2)
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
