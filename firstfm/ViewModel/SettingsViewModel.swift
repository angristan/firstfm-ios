import Foundation
import Kingfisher
import Cache
import os

class SettingsViewModel: ObservableObject {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: SettingsViewModel.self)
    )

    @Published var cacheSize: Swift.Result<UInt, KingfisherError> = .success(UInt(0))

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

    func clearCache() {
        let diskConfig = DiskConfig(name: "firstfm.spotify.images")
        let memoryConfig = MemoryConfig()

        let storage = try? Storage<String, SpotifyImage>(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: SpotifyImage.self)
        )

        do {
            try storage?.removeAll()
        } catch {
            SettingsViewModel.logger.error("clearCache error = \(error.localizedDescription)")
        }

        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}
