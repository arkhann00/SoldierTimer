//
//  MainTabView.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import SwiftUI
import Combine

struct MainTabView: View {
    @StateObject private var timerVM: TimerViewModel
    @StateObject private var calendarVM: CalendarViewModel

    init(makeTimerVM: @escaping () -> TimerViewModel,
         makeCalendarVM: @escaping () -> CalendarViewModel) {
        _timerVM = StateObject(wrappedValue: makeTimerVM())
        _calendarVM = StateObject(wrappedValue: makeCalendarVM())
    }

    var body: some View {
        TabView {
            TimerView(vm: timerVM)
                .tabItem { Label("Timer", systemImage: "timer") }

            CalendarView(vm: calendarVM)
                .tabItem { Label("Calendar", systemImage: "calendar") }
        }
    }
}
