// MemoryStats.swift
import Foundation
import Darwin

struct MemSample {
    let used: UInt64
    let free: UInt64
    let total: UInt64
    let app: UInt64
    let wired: UInt64
    let compressed: UInt64
    let cachedFiles: UInt64
}

func readMemory() -> MemSample? {
    // Total physical RAM
    var phys: UInt64 = 0
    var len = MemoryLayout<UInt64>.size
    guard sysctlbyname("hw.memsize", &phys, &len, nil, 0) == 0 else { return nil }

    // VM stats
    var vm = vm_statistics64()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
    let k = withUnsafeMutablePointer(to: &vm) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
        }
    }
    guard k == KERN_SUCCESS else { return nil }

    // Page size
    var pageSize: vm_size_t = 0
    host_page_size(mach_host_self(), &pageSize)
    let PS = UInt64(pageSize)

    // Derive Activity Monitor-like buckets
    let purgeable     = UInt64(vm.purgeable_count)       * PS
    let internalAnon  = UInt64(vm.internal_page_count)   * PS
    let externalFiles = UInt64(vm.external_page_count)   * PS
    let wired         = UInt64(vm.wire_count)            * PS
    let compressed    = UInt64(vm.compressor_page_count) * PS

    let app         = internalAnon &- purgeable
    let cachedFiles = externalFiles &+ purgeable
    let used        = app &+ wired &+ compressed
    let free: UInt64 = phys > used ? (phys - used) : 0

    return MemSample(used: used, free: free, total: phys,
                     app: app, wired: wired, compressed: compressed, cachedFiles: cachedFiles)
}

func formatGB(_ bytes: UInt64) -> String {
    let gb = Double(bytes) / 1_073_741_824.0 // GiB
    return String(format: "%.1f", gb)
}

func getSwapUsage() -> String {
    var swap = xsw_usage()
    var size = MemoryLayout<xsw_usage>.size
    if sysctlbyname("vm.swapusage", &swap, &size, nil, 0) != 0 { return "–" }
    return String(format: "%.1f GB", Double(swap.xsu_used) / 1_073_741_824.0)
}

