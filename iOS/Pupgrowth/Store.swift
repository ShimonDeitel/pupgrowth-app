import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 8 // seed data has 3 entries; keep this above that

    @Published var entries: [MilestoneEntry] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("pupgrowth_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: MilestoneEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: MilestoneEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: MilestoneEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([MilestoneEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        MilestoneEntry(date: Date().addingTimeInterval(-604800), title: "Sample 1", notes: "Sample 1"),
        MilestoneEntry(date: Date().addingTimeInterval(-1209600), title: "Sample 2", notes: "Sample 2"),
        MilestoneEntry(date: Date().addingTimeInterval(-1814400), title: "Sample 3", notes: "Sample 3")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }
}
