//
//  Clock.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

protocol Clock: Sendable {
    func ticks(every interval: Duration) -> AsyncStream<Date>
}