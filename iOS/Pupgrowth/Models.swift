import Foundation

struct MilestoneEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var title: String
    var notes: String
    var createdAt: Date = Date()
}
