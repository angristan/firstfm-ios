import Foundation
import Kingfisher

class SettingsViewModel: ObservableObject {
    @Published var cacheSize: Result<UInt, KingfisherError> = .success(UInt(0))

    func getCacheSize() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
                self.cacheSize = .success(size)
            case .failure(let error):
                self.cacheSize = .failure(error)
            }
        }
    }
}
