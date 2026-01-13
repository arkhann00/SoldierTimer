//
//  SwiftDataStore.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation
import SwiftData

actor SwiftDataStore {
    private let container: ModelContainer

    init() {
        self.container = try! ModelContainer(for: SettingsModel.self, HolidayCacheModel.self)
    }

    func getDemobDate() throws -> Date? {
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<SettingsModel>(predicate: #Predicate { $0.key == "main" })
        let item = try ctx.fetch(desc).first
        return item?.demobDate
    }

    func setDemobDate(_ date: Date?) throws {
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<SettingsModel>(predicate: #Predicate { $0.key == "main" })
        if let item = try ctx.fetch(desc).first {
            item.demobDate = date
        } else {
            ctx.insert(SettingsModel(key: "main", demobDate: date))
        }
        try ctx.save()
    }

    func getHolidayCache(year: Int, countryCode: String) throws -> Data? {
        let key = "\(year)|\(countryCode)"
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<HolidayCacheModel>(predicate: #Predicate { $0.cacheKey == key })
        return try ctx.fetch(desc).first?.payload
    }

    func saveHolidayCache(year: Int, countryCode: String, payload: Data) throws {
        let key = "\(year)|\(countryCode)"
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<HolidayCacheModel>(predicate: #Predicate { $0.cacheKey == key })
        if let item = try ctx.fetch(desc).first {
            item.payload = payload
            item.fetchedAt = Date()
        } else {
            ctx.insert(HolidayCacheModel(year: year, countryCode: countryCode, fetchedAt: Date(), payload: payload))
        }
        try ctx.save()
    }
}