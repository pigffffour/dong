import Foundation
import Combine

/// 管理连续打卡记录
@MainActor
final class StreakManager: ObservableObject {
    @Published private(set) var streakData: StreakData
    
    private let persistence: PersistenceServiceProtocol
    
    init(persistence: PersistenceServiceProtocol) {
        self.persistence = persistence
        self.streakData = (try? persistence.loadStreakData()) ?? StreakData()
    }
    
    var currentStreak: Int { streakData.currentStreak }
    var longestStreak: Int { streakData.longestStreak }
    
    /// 标记今天为活跃日（至少完成一项健康活动即调用）
    func markTodayActive() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = streakData.lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            if lastDay == today {
                return // 今天已标记
            }
            let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if daysBetween == 1 {
                streakData.currentStreak += 1
            } else {
                streakData.currentStreak = 1 // 连续中断
            }
        } else {
            streakData.currentStreak = 1
        }
        
        streakData.lastActiveDate = today
        if streakData.currentStreak > streakData.longestStreak {
            streakData.longestStreak = streakData.currentStreak
        }
        
        try? persistence.saveStreakData(streakData)
    }
    
    /// 检查连续是否已中断（app 启动时调用）
    func checkStreakContinuity() {
        guard let lastDate = streakData.lastActiveDate else { return }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDay = calendar.startOfDay(for: lastDate)
        let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        if daysBetween > 1 {
            streakData.currentStreak = 0
            try? persistence.saveStreakData(streakData)
        }
    }
}
