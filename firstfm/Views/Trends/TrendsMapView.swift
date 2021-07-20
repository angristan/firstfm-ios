import SwiftUI
import MapKit

struct TrendsMapView: View {
    @ObservedObject var vm = TrendsViewModel()
    @State private var showingSheet = false
    @StateObject var countryVM = TopCountryViewModel()

    @State var coordinateRegion: MKCoordinateRegion = {
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = 37.786996
        newRegion.center.longitude = -122.440100
        newRegion.span.latitudeDelta = 0.2
        newRegion.span.longitudeDelta = 0.2
        return newRegion
    }()

    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion,
                annotationItems: vm.annotationItems) {item in
                MapAnnotation(coordinate: item.coordinate) {
                    Button(action: {
                        print("item: \(item)")
                        countryVM.country = item.country
                        countryVM.isLoading = true
                        countryVM.artists = []
                        countryVM.getTopArtists(country: item.country)
                        showingSheet.toggle()
                    }) {
                        Text(item.country.emoji())
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
