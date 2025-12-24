import SwiftUI

struct TimerView: View {
    @ObservedObject var vm: TimerViewModel

    var body: some View {
        VStack(spacing: 16) {
            switch vm.state {
            case .loading:
                ProgressView()

            case .noDate:
                Text("Укажи дату дембеля во вкладке Calendar")

            case .running(let snap):
                Text("До дембеля осталось")
                    .font(.headline)

                Text("\(snap.days)д \(snap.hours)ч \(snap.minutes)м \(snap.seconds)с")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .monospacedDigit()

                Text("Дата: \(snap.targetDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.secondary)

            case .error(let msg):
                Text(msg)
            }
        }
        .padding()
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisappear() }
    }
}