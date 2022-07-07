import SwiftUI

struct LoginGuardView: View {
    @State private var showingSheet = false

    var body: some View {
        VStack {
            Text("Please login to access your stats!")

            Button(action: {
                showingSheet.toggle()
            }) {
                LoginButton()
            }
                    .sheet(isPresented: $showingSheet) {
                        LoginView()
                    }
        }
    }
}
