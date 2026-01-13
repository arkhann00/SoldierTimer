//
//  TimerViewModel.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation
import Combine

@MainActor
final class TimerViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case noDate
        case running(CountdownSnapshot)
        case error(String)
    }

    @Published private(set) var state: State = .loading

    private let getDemob: GetDemobDateUseCase
    private let clock: Clock
    private var tickTask: Task<Void, Never>?

    init(getDemob: GetDemobDateUseCase, clock: Clock) {
        self.getDemob = getDemob
        self.clock = clock
    }

    func onAppear() {
        tickTask?.cancel()
        tickTask = Task { await run() }
    }

    func onDisappear() {
        tickTask?.cancel()
        tickTask = nil
    }

    private func run() async {
        do {
            guard let target = try await getDemob.execute() else {
                state = .noDate
                return
            }

            // Реактивность: обновляемся каждую секунду
            for await now in clock.ticks(every: .seconds(1)) {
                let remaining = Int(target.timeIntervalSince(now).rounded(.down))
                let snap = CountdownSnapshot(targetDate: target, now: now, remainingSeconds: remaining)
                state = .running(snap)
                if snap.isFinished { break }
            }
        } catch {
            state = .error("Не удалось загрузить дату дембеля")
        }
    }
}
