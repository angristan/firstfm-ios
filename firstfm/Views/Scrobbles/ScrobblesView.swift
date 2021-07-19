//
//  ScrobblesView.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

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
                            destination: Color(.blue),
                            label: {
                                ScrobbledTrackRow(track: track)
                            })
                    }.navigationTitle("Scrobbles").onAppear {
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
                    ProgressView()
                }
            }

        }
    }
}
