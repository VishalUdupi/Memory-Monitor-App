# Memory Monitor (macOS)

A lightweight macOS application for monitoring system memory usage with minimal
runtime overhead.

The app is designed to run continuously and provide a clear view of memory
pressure without relying on heavyweight system monitoring tools.

## Motivation

While macOS provides basic memory information through Activity Monitor, it is
not always convenient for continuous or quick-glance usage. Many third-party
tools also introduce unnecessary background load or excessive UI complexity.

This app was built to provide:

- Simple visibility into memory usage
- Predictable and low resource consumption
- A native Swift and SwiftUI implementation
- No external dependencies

## Features

- Displays total, used, free, and inactive memory
- Uses native macOS system APIs for memory statistics
- Updates at a controlled polling interval
- Minimal UI designed for clarity
- Suitable for long-running background use

## Design Goals

- Low CPU usage
- Low memory footprint
- Avoid unnecessary allocations
- Avoid aggressive polling
- Native macOS behavior

The app prioritizes stability and predictability over feature breadth.

## Implementation Overview

Memory statistics are collected using native Mach APIs exposed by macOS.
The core logic is isolated from the UI layer to keep data collection simple
and testable.

### Key Components

- `MemoryStats.swift`  
  Responsible for querying system memory statistics and translating raw values
  into usable metrics.

- `MemoryMonitorApp.swift`  
  Application entry point and lifecycle management.

- `ContentView.swift` and `MemoryView.swift`  
  SwiftUI views responsible for presenting memory information.

The UI layer reacts to published state updates rather than polling directly,
which keeps rendering overhead low.

## Polling Strategy

Memory statistics are fetched at a fixed interval chosen to balance freshness
with system impact.

The app avoids high-frequency polling to prevent unnecessary CPU wakeups and
energy usage. The polling interval can be adjusted if needed.

## Performance Characteristics

In normal operation:

- CPU usage remains negligible
- Memory footprint remains stable
- No observable impact on system responsiveness

The app is suitable for continuous execution.

## Entitlements and Permissions

The app uses minimal entitlements and does not require network access or
elevated privileges.

All memory statistics are obtained through documented macOS system interfaces.

## Limitations

- Does not provide per-process memory breakdowns
- Does not track historical memory usage over time
- macOS restricts access to certain low-level metrics

The app intentionally focuses on system-level memory visibility only.

## Build and Run

- macOS version: macOS 12 or newer recommended
- Xcode: Latest stable version recommended

To run:
1. Open the project in Xcode
2. Select the macOS target
3. Build and run

## Future Improvements

Potential enhancements include:

- Menu bar integration
- Optional historical charts
- Configurable update intervals
- Optional memory pressure indicators
