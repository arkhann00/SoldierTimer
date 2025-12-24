//
//  SettingsRepositoryImpl.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

final class SettingsRepositoryImpl: SettingsRepository {
    private let store: SwiftDataStore
    init(store: SwiftDataStore) { self.store = store }

    func getDemobDate() async throws -> Date? {
        try await store.getDemobDate()
    }

    func setDemobDate(_ date: Date?) async throws {
        try await store.setDemobDate(date)
    }
}