import SwiftUI
import Combine

@main
struct SoldierTimerApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            MainTabView(
                makeTimerVM: { container.makeTimerVM() },
                makeCalendarVM: { container.makeCalendarVM() }
            )
        }
    }
}
