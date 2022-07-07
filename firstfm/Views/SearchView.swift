import SwiftUI
import os

struct SearchView: View {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: SearchView.self)
    )

    @ObservedObject var search = SearchViewModel()
    @State var searchString: String = ""
    @State private var selectedSearchType = 0

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Justin Bieber, Micheal Jackson...",
                            text: $searchString,
                            onCommit: { self.performSearch() })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: { self.performSearch() }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                        .padding()

                // Not actually working
                Picker("Search type",
                        selection: $selectedSearchType,
                        content: {
                            Text("Artists").tag(0)
                            Text("Albums").tag(1)
                            Text("Tracks").tag(2)
                        })
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .pickerStyle(SegmentedPickerStyle())

                List {
                    ForEach(search.artists) { artist in
                        NavigationLink(
                                destination: ArtistView(artist: artist),
                                label: {
                                    ArtistRow(artist: artist)
                                })
                    }
                }
                        .navigationBarTitle("Search")
            }
        }
    }

    func performSearch() {
        SearchView.logger.info("Searching for \(searchString)")
        self.search.searchForArtist(artist: searchString)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
