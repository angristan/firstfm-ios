import Foundation

extension NSLocale {
    class func localeForCountry(countryName: String) -> String? {
        return NSLocale.isoCountryCodes.first {
            self.countryNameFromLocaleCode(localeCode: $0) == countryName
        }
    }

    private class func countryNameFromLocaleCode(localeCode: String) -> String {
        return NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.countryCode, value: localeCode) ?? ""
    }
}

struct Country: Codable {
    let name: String
    let lat, long: Double

    func flag(country: String) -> String {
        let base: UInt32 = 127397
        var fullString = ""
        for scalar in country.unicodeScalars {
            fullString.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return String(fullString)
    }

    func emoji() -> String {
        let emoji = self.flag(country: NSLocale.localeForCountry(countryName: self.name) ?? "⚠️")

        print("\(self.name): \(emoji)")

        return emoji
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Country(name: name, lat: lat, long: long)
        return copy
    }
}
