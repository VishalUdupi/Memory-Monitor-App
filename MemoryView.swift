// MemoryView.swift
import SwiftUI

struct MemoryView: View {
    @State private var mem: MemSample?
    @State private var swapText: String = "–"

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let m = mem {
                Text("Memory Used: \(formatGB(m.used)) / \(formatGB(m.total)) GB")
                Text("App: \(formatGB(m.app)) GB")
                Text("Wired: \(formatGB(m.wired)) GB")
                Text("Compressed: \(formatGB(m.compressed)) GB")
                Text("Cached Files: \(formatGB(m.cachedFiles)) GB")
                Text("Swap: \(swapText)").padding(.top, 4)
            } else {
                Text("Loading…")
            }
            Divider().padding(.vertical, 6)
            HStack {
                Button("Refresh Now") { refresh() }
                Spacer()
                Text("Every 2s").foregroundColor(.secondary)
            }
        }
        .padding(12)
        .onAppear {
            refresh()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                refresh()
            }
        }
    }

    private func refresh() {
        mem = readMemory()
        swapText = getSwapUsage()
    }
}

