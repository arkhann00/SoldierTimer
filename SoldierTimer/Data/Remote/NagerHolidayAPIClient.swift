//
//  NagerHolidayAPIClient.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

final class NagerHolidayAPIClient: @unchecked Sendable {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func fetch(year: Int, countryCode: String) async throws -> [NagerHolidayDTO] {
        // Документация/эндпоинт: /api/v3/PublicHolidays/{year}/{countryCode}
        // https://date.nager.at/api/v3/PublicHolidays/2026/US  [oai_citation:1‡date.nager.at](https://date.nager.at/API?utm_source=chatgpt.com)
        let url = URL(string: "https://date.nager.at/api/v3/PublicHolidays/\(year)/\(countryCode)")!
        let (data, resp) = try await session.data(from: url)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([NagerHolidayDTO].self, from: data)
    }
}