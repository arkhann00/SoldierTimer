import Foundation

struct GetHolidaysUseCase {
    let repo: HolidayRepository

    /// Возвращает (cached, updatedRemote) — UI может сначала показать кеш и потом обновиться.
    func execute(year: Int, countryCode: String) async throws -> (cached: [Holiday]?, fresh: [Holiday]) {
        async let cached = repo.getCachedHolidays(year: year, countryCode: countryCode)
        async let fresh = repo.fetchRemoteHolidays(year: year, countryCode: countryCode)
        let (c, f) = try await (cached, fresh)
        try await repo.saveCache(year: year, countryCode: countryCode, holidays: f)
        return (c, f)
    }
}