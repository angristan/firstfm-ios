import SwiftUI
import SwiftUIRefresh

struct Scrobbles: View {
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var vm = ScrobblesViewModel()
    @State var scrobblesLoaded = false
    @State private var isPullLoaderShowing = false

    var body: some View {
        NavigationView {
            if auth.isLoggedIn() {
                ZStack {
                    VStack {
                        List {
                            ForEach(vm.scrobbles, id: \.self) { track in
                                NavigationLink(
                                        destination: TrackView(track: Track(name: track.name, playcount: "0", listeners: "", url: "", artist: nil, image: track.image)),
                                        label: {
                                            ScrobbledTrackRow(track: track)
                                        })
                                        .onAppear {
                                            print("last: [\(vm.scrobbles.last?.name ?? "fail")] current: [\(track.name)]")
                                            if vm.scrobbles.last == track {
                                                self.vm.getNextPage()
                                            }
                                        }
                            }
                            if !vm.scrobbles.isEmpty && vm.isLoading {
                                loadingIndicator.padding()
                            }
                        }
                                .navigationTitle("Your scrobbles").onAppear {
                                    if !scrobblesLoaded {
                                        vm.getUserScrobbles()
                                        // Prevent loading again when navigating
                                        scrobblesLoaded = true
                                    }
                                }
                                .pullToRefresh(isShowing: $isPullLoaderShowing) {
                                    vm.getUserScrobbles(page: 1, clear: true)
                                    self.isPullLoaderShowing = false
                                }
                    }
                    // Show loader above the rest of the ZStack
                    if vm.isLoading && vm.scrobbles.isEmpty {
                        // TODO: replace with redacted?
                        ProgressView().scaleEffect(2)
                    }
                }

            } else {
                SrobblesLoggedOutView()
            }
        }
    }

    private var loadingIndicator: some View {
        ProgressView()
                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}
