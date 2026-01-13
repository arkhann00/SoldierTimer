//
//  HolidayRepositoryImpl.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation
import Combine

final class HolidayRepositoryImpl: HolidayRepository {
    private let store: SwiftDataStore
    private let api: NagerHolidayAPIClient

    init(store: SwiftDataStore, api: NagerHolidayAPIClient) {
        self.store = store
        self.api = api
    }

    func getCachedHolidays(year: Int, countryCode: String) async throws -> [Holiday]? {
        guard let data = try await store.getHolidayCache(year: year, countryCode: countryCode) else { return nil }
        let dtos = try JSONDecoder().decode([NagerHolidayDTO].self, from: data)
        return dtos.compactMap(HolidayMapper.toDomain)
    }

    func fetchRemoteHolidays(year: Int, countryCode: String) async throws -> [Holiday] {
        let dtos = try await api.fetch(year: year, countryCode: countryCode)
        return dtos.compactMap(HolidayMapper.toDomain)
    }

    func saveCache(year: Int, countryCode: String, holidays: [Holiday]) async throws {
        // Храним как DTO-массив в JSON (простая кеш-стратегия)
        // Для этого обратного маппера достаточно, чтобы не городить лишнее:
        let dtos: [NagerHolidayDTO] = holidays.map { h in
            let df = DateFormatter()
            df.calendar = Calendar(identifier: .iso8601)
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"
            return NagerHolidayDTO(date: df.string(from: h.date), localName: h.localName, name: h.name)
        }
        let data = try JSONEncoder().encode(dtos)
        try await store.saveHolidayCache(year: year, countryCode: countryCode, payload: data)
    }
}
