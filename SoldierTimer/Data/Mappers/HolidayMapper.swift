import Foundation

enum HolidayMapper {
    static func toDomain(_ dto: NagerHolidayDTO) -> Holiday? {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"

        guard let date = df.date(from: dto.date) else { return nil }
        return Holiday(id: dto.date + "|" + dto.name, date: date, localName: dto.localName, name: dto.name)
    }
}