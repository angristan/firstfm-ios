import SwiftUI
import MapKit

struct TrendsMapView: View {
    @ObservedObject var vm = TrendsViewModel()
    @State private var showingSheet = false
    @StateObject var countryVM = TopCountryViewModel()

    @State var coordinateRegion: MKCoordinateRegion = {
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = 48.5776871
        newRegion.center.longitude = 2.2225161
        newRegion.span.latitudeDelta = 20
        newRegion.span.longitudeDelta = 20
        return newRegion
    }()

    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion,
                    annotationItems: vm.annotationItems) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Button(action: {
                        print("item: \(item)")
                        countryVM.country = item.country
                        countryVM.isLoading = true
                        countryVM.artists = []
                        countryVM.getTopArtists(country: item.country)
                        showingSheet.toggle()
                    }) {
                        Text(item.country.emoji()).font(.system(size: 20))
                    }
                            .sheet(isPresented: $showingSheet) {
                                TopCountryView()
                                        .environmentObject(countryVM)
                            }
                }
            }
        }
    }
}
