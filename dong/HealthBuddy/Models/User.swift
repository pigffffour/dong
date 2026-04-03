import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var phoneNumber: String
    var displayName: String
    var avatarEmoji: String
    var bodyProfile: BodyProfile
    var createdAt: Date
    var updatedAt: Date
    
    init(phoneNumber: String) {
        self.id = UUID()
        self.phoneNumber = phoneNumber
        self.displayName = ""
        self.avatarEmoji = "🐻"
        self.bodyProfile = BodyProfile()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(id: UUID, phoneNumber: String, displayName: String,
         avatarEmoji: String, bodyProfile: BodyProfile,
         createdAt: Date, updatedAt: Date) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.displayName = displayName
        self.avatarEmoji = avatarEmoji
        self.bodyProfile = bodyProfile
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
