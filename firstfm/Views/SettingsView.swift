import SwiftUI

struct SettingsView: View {
    @AppStorage("lastfm_username") var storedUsername: String?
    @ObservedObject var settings = SettingsViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Label {
                        Text("Default time period for tops")
                                .font(.body)
                                .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    switch settings.cacheSize {
                    case .success(let size):
                        Text("Disk cache size: \(Int(size) / 1024 / 1024) MB")
                    case .failure(let error):
                        Text("Failed to get cache size: \(error.errorDescription ?? "unknown error")")
                    }
                    Button(action: {
                        settings.clearCache()
                        settings.getCacheSize()

                    }) {
                        Label {
                            Text("Clear cache")
                                    .font(.body)
                                    .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
                }

                Section(header: Text("Account")) {
                    Button(action: {
                        storedUsername = nil
                    }) {
                        Label {
                            Text("Log out")
                                    .font(.body)
                                    .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "person.crop.circle.badge.xmark")
                        }
                    }
                }

                Section(header: Text("About the app"), footer: Text("Version 1.x.x")) {
                    Label {
                        Text("Source code and issues")
                                .font(.body)
                                .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "link")
                    }
                }
            }
                    .onAppear {
                        settings.getCacheSize()
                    }
                    .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
