import Foundation

enum HealthRecordType: String, Codable {
    case steps
    case sleep
    case activeEnergy
    // Future modules
    case waterIntake
    case exerciseSession
    case heartRate
}

struct HealthRecord: Codable, Identifiable {
    let id: UUID
    let type: HealthRecordType
    let value: Double
    let unit: String
    let startDate: Date
    let endDate: Date
    let metadata: [String: String]?
    let source: RecordSource
    var syncStatus: SyncStatus
    let createdAt: Date
    
    enum RecordSource: String, Codable {
        case healthKit
        case manual
        case camera
    }
    
    enum SyncStatus: String, Codable {
        case pending
        case synced
        case conflicted
    }
    
    init(type: HealthRecordType, value: Double, unit: String,
         startDate: Date, endDate: Date,
         source: RecordSource = .healthKit,
         metadata: [String: String]? = nil) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.unit = unit
        self.startDate = startDate
        self.endDate = endDate
        self.source = source
        self.metadata = metadata
        self.syncStatus = .pending
        self.createdAt = Date()
    }
}
