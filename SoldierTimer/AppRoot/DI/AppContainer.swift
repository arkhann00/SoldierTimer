//
//  AppContainer.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation
import Combine

@MainActor
final class AppContainer: ObservableObject {
    private let store = SwiftDataStore()

    private lazy var settingsRepo: SettingsRepository = SettingsRepositoryImpl(store: store)
    private lazy var holidayRepo: HolidayRepository = HolidayRepositoryImpl(
        store: store,
        api: NagerHolidayAPIClient()
    )
    private let clock: Clock = SystemClock()

    func makeTimerVM() -> TimerViewModel {
        TimerViewModel(
            getDemob: GetDemobDateUseCase(repo: settingsRepo),
            clock: clock
        )
    }

    func makeCalendarVM() -> CalendarViewModel {
        CalendarViewModel(
            getDemob: GetDemobDateUseCase(repo: settingsRepo),
            setDemob: SetDemobDateUseCase(repo: settingsRepo),
            getHolidays: GetHolidaysUseCase(repo: holidayRepo)
        )
    }
}
