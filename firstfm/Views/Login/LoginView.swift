import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct LoginView: View {

    @Environment(\.presentationMode) var presentationMode

    @State var password: String = ""
    @State var username: String = ""
    @State private var isShowingProfile = false
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("lastfm_username") var storedUsername: String?

    var body: some View {
        VStack {
            WelcomeText().onTapGesture {
                self.hideKeyboard()
            }
            TextField("Username", text: $username)
                .textContentType(.username)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {
                storedUsername = username
                auth.login(username: username, password: password)
                presentationMode.wrappedValue.dismiss()
            }) {
                LoginButton()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .padding()
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif

struct WelcomeText: View {
    var body: some View {
        return Text("Login to last.fm")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LoginButton: View {
    var body: some View {
        return Text("Login")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color(red: 185 / 255, green: 0 / 255, blue: 0 / 255))
            .cornerRadius(15.0)
    }
}
