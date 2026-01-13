import Foundation
import Combine

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

            state = .loaded(demob: demob, holidays: result.fresh)
        } catch {
            state = .error("Не удалось загрузить праздники")
        }
    }
}
