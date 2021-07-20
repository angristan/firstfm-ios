import SwiftUI

@main
struct FirstfmApp: App {

    @StateObject var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
            }.accentColor(.red)
            .environmentObject(auth)
        }
    }
}
