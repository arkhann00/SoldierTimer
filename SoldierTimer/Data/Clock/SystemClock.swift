//
//  SystemClock.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

struct SystemClock: Clock {
    func ticks(every interval: Duration) -> AsyncStream<Date> {
        AsyncStream { continuation in
            let task = Task {
                while !Task.isCancelled {
                    continuation.yield(Date())
                    try? await Task.sleep(for: interval)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}