import Foundation

struct GetDemobDateUseCase {
    let repo: SettingsRepository
    func execute() async throws -> Date? { try await repo.getDemobDate() }
}

struct SetDemobDateUseCase {
    let repo: SettingsRepository
    func execute(_ date: Date?) async throws { try await repo.setDemobDate(date) }
}