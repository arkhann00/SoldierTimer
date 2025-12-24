import Foundation
import SwiftData

@Model
final class SettingsModel {
    @Attribute(.unique) var key: String
    var demobDate: Date?

    init(key: String = "main", demobDate: Date? = nil) {
        self.key = key
        self.demobDate = demobDate
    }
}

@Model
final class HolidayCacheModel {
    @Attribute(.unique) var cacheKey: String // "\(year)|\(countryCode)"
    var year: Int
    var countryCode: String
    var fetchedAt: Date
    var payload: Data

    init(year: Int, countryCode: String, fetchedAt: Date, payload: Data) {
        self.cacheKey = "\(year)|\(countryCode)"
        self.year = year
        self.countryCode = countryCode
        self.fetchedAt = fetchedAt
        self.payload = payload
    }
}