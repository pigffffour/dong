import Foundation

struct BodyProfile: Codable {
    var heightCm: Double?
    var weightKg: Double?
    var age: Int?
    var gender: Gender?
    var activityLevel: ActivityLevel
    
    var isComplete: Bool {
        heightCm != nil && weightKg != nil && age != nil && gender != nil
    }
    
    var bmi: Double? {
        guard let h = heightCm, let w = weightKg, h > 0 else { return nil }
        let heightM = h / 100.0
        return w / (heightM * heightM)
    }
    
    /// Basal Metabolic Rate (Mifflin-St Jeor)
    var bmr: Double? {
        guard let w = weightKg, let h = heightCm, let a = age, let g = gender else { return nil }
        switch g {
        case .male:   return 10 * w + 6.25 * h - 5 * Double(a) + 5
        case .female: return 10 * w + 6.25 * h - 5 * Double(a) - 161
        case .other:  return 10 * w + 6.25 * h - 5 * Double(a) - 78
        }
    }
    
    /// Total Daily Energy Expenditure
    var tdee: Double? {
        guard let bmr = bmr else { return nil }
        return bmr * activityLevel.multiplier
    }
    
    enum Gender: String, Codable, CaseIterable {
        case male
        case female
        case other
        
        var displayName: String {
            switch self {
            case .male: return "男"
            case .female: return "女"
            case .other: return "其他"
            }
        }
    }
    
    enum ActivityLevel: String, Codable, CaseIterable {
        case sedentary
        case lightlyActive
        case moderatelyActive
        case veryActive
        
        var multiplier: Double {
            switch self {
            case .sedentary:        return 1.2
            case .lightlyActive:    return 1.375
            case .moderatelyActive: return 1.55
            case .veryActive:       return 1.725
            }
        }
        
        var displayName: String {
            switch self {
            case .sedentary:        return "久坐不动"
            case .lightlyActive:    return "轻度活跃"
            case .moderatelyActive: return "中度活跃"
            case .veryActive:       return "非常活跃"
            }
        }
    }
    
    init() {
        self.activityLevel = .lightlyActive
    }
}
