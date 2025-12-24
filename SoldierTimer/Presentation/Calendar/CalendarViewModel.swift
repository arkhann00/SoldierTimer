//
//  CalendarViewModel.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

@MainActor
final class CalendarViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(demob: Date?, holidays: [Holiday])
        case error(String)
    }

    @Published private(set) var state: State = .loading
    @Published var selectedDemobDate: Date = Date()

    private let getDemob: GetDemobDateUseCase
    private let setDemob: SetDemobDateUseCase
    private let getHolidays: GetHolidaysUseCase

    // Можно позже сделать выбор страны в UI.
    private let countryCode = "RU"

    init(getDemob: GetDemobDateUseCase,
         setDemob: SetDemobDateUseCase,
         getHolidays: GetHolidaysUseCase) {
        self.getDemob = getDemob
        self.setDemob = setDemob
        self.getHolidays = getHolidays
    }

    func onAppear() {
        Task { await load() }
    }

    func saveDemobDate() {
        Task {
            do {
                try await setDemob.execute(selectedDemobDate)
                await load()
            } catch {
                state = .error("Не удалось сохранить дату")
            }
        }
    }

    private func load() async {
        state = .loading
        do {
            let demob = try await getDemob.execute()
            if let demob { selectedDemobDate = demob }

            let year = Calendar.current.component(.year, from: Date())
            let result = try await getHolidays.execute(year: year, countryCode: countryCode)

            // Если кеш был — можно было бы сначала показать его, потом fresh.
            state = .loaded(demob: demob, holidays: result.fresh)
        } catch {
            state = .error("Не удалось загрузить праздники")
        }
    }
}