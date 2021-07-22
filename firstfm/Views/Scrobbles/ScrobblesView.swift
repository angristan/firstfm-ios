import SwiftUI
import SwiftUIRefresh

struct Scrobbles: View {
    @ObservedObject var vm = ScrobblesViewModel()
    @State var scrobblesLoaded = false
    @State private var isPullLoaderShowing = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List(vm.scrobbles) { track in
                        NavigationLink(
                            destination: TrackView(track: Track(name: track.name, playcount: "0", listeners: "", url: "", artist: nil, image: track.image)),
                            label: {
                            ScrobbledTrackRow(track: track)
                        })
                    }.navigationTitle("Your scrobbles").onAppear {
                        if !scrobblesLoaded {
                            vm.getUserScrobbles()
                            // Prevent loading again when navigating
                            scrobblesLoaded = true
                        }
                    }
                    .pullToRefresh(isShowing: $isPullLoaderShowing) {
                        vm.getUserScrobbles()
                        self.isPullLoaderShowing = false
                    }
                }
                // Show loader above the rest of the ZStack
                if vm.isLoading {
                    ProgressView().scaleEffect(2)
                }
            }

        }
    }
}
