//
//  CalendarView.swift
//  SoldierTimer
//
//  Created by Арсен Хачатрян on 24.12.2025.
//


import SwiftUI
import Combine

struct CalendarView: View {
    @ObservedObject var vm: CalendarViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 6) {
                Group {
                    Text("Дата дембеля")
                        .font(.headline)

                    DatePicker("",
                               selection: $vm.selectedDemobDate,
                               displayedComponents: [.date])
                    .datePickerStyle(.graphical)

                    Button("Сохранить дату") { vm.saveDemobDate() }
                }

                Divider()
                switch vm.state {
                case .loading:
                    ProgressView()

                case .loaded(_, let holidays):
                    List(holidays) { h in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(h.localName)
                            Text(h.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(.secondary)
                        }
                    }

                case .error(let msg):
                    Text(msg)
                }
                
            }
            .padding()
            .navigationTitle("Calendar")
        }
        .onAppear { vm.onAppear() }
    }
}
