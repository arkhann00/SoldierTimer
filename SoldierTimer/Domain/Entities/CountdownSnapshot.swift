//
//  CountdownSnapshot 2.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import Foundation

struct CountdownSnapshot: Equatable, Sendable {
    let targetDate: Date
    let now: Date
    let remainingSeconds: Int

    var isFinished: Bool { remainingSeconds <= 0 }

    var days: Int { max(0, remainingSeconds) / 86_400 }
    var hours: Int { (max(0, remainingSeconds) % 86_400) / 3_600 }
    var minutes: Int { (max(0, remainingSeconds) % 3_600) / 60 }
    var seconds: Int { max(0, remainingSeconds) % 60 }
}