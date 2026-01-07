import SwiftUI

@main
struct MemoryMonitorApp: App {
    var body: some Scene {
        MenuBarExtra("RAM", systemImage: "memorychip") {
            MemoryView()
        }
        .menuBarExtraStyle(.window) // Ensures lightweight dropdown
    }
}

