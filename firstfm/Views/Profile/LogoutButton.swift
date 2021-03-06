import Foundation
import SwiftUI

struct LogoutButton: View {
    var body: some View {
        return Text("Logout")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 100, height: 60)
                .background(Color(red: 185 / 255, green: 0 / 255, blue: 0 / 255))
                .cornerRadius(15.0)
    }
}
