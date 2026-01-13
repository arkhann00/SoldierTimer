//
//  Holiday.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//

import Foundation

struct Holiday: Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let localName: String
    let name: String
}
