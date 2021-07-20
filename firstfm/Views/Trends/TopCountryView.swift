import SwiftUI

struct TopCountryView: View {
    //    let country: Country
    @EnvironmentObject var vm: TopCountryViewModel
    @State var artistsLoaded = false

    //    Text("Top artists in \(country.name) \(country.emoji())").font(.headline)

    var body: some View {
        NavigationView {

            if let country = vm.country {
                ZStack {
                    List {
                        ForEach(vm.artists) { artist in
                            ZStack {
                                Button("") {}
                                NavigationLink(
                                    destination: ArtistView(artist: artist),
                                    label: {
                                    ArtistRow(artist: artist)
                                })
                            }
                        }
                    }
                    .navigationTitle("Top artists in \(country.name) \(country.emoji())").onAppear {
                        print("\(country.name) self.artistsLoaded: \(self.artistsLoaded) ")
                        if !self.artistsLoaded {
//                            vm.getTopArtists(country: country)
                            // Prevent loading artists again when navigating
//                            self.artistsLoaded = true
                        }
                    }
                    //                        .pullToRefresh(isShowing: $isPullLoaderShowing) {
                    //                            self.charts.getChartingArtists()
                    //                            self.isPullLoaderShowing = false
                    //                        }

                    // Show loader above the rest of the ZStack
                    if vm.isLoading {
                        ProgressView().scaleEffect(2)
                    }
                }
            } else {
                Text("Error")
            }
        }
    }
}
