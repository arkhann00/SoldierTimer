//
//  SettingsRepository.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

protocol SettingsRepository: Sendable {
    func getDemobDate() async throws -> Date?
    func setDemobDate(_ date: Date?) async throws
}

protocol HolidayRepository: Sendable {
    func getCachedHolidays(year: Int, countryCode: String) async throws -> [Holiday]?
    func fetchRemoteHolidays(year: Int, countryCode: String) async throws -> [Holiday]
    func saveCache(year: Int, countryCode: String, holidays: [Holiday]) async throws
}