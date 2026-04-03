import Foundation

struct DecorationItem: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let iconName: String
    let category: DecorationCategory
    let levelRequired: Int
    let description: String
    
    enum DecorationCategory: String, Codable, CaseIterable {
        case hat = "头饰"
        case accessory = "配饰"
        case backpack = "背包"
        case theme = "主题"
    }
    
    static func == (lhs: DecorationItem, rhs: DecorationItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum DecorationCatalog {
    static let all: [DecorationItem] = [
        DecorationItem(id: "deco_strawhat", name: "草帽", iconName: "hat.widebrim.fill", category: .hat, levelRequired: 1, description: "一顶简单的草帽，遮阳必备。"),
        DecorationItem(id: "deco_redbowtie", name: "红色领结", iconName: "tie.fill", category: .accessory, levelRequired: 3, description: "绅士熊的标配。"),
        DecorationItem(id: "deco_sportglasses", name: "运动眼镜", iconName: "eyeglasses", category: .accessory, levelRequired: 5, description: "看起来很有活力！"),
        DecorationItem(id: "deco_headphones", name: "运动耳机", iconName: "headphones", category: .accessory, levelRequired: 7, description: "边运动边听歌。"),
        DecorationItem(id: "deco_scarf", name: "暖暖围巾", iconName: "wind", category: .accessory, levelRequired: 8, description: "冬日里的温暖。"),
        DecorationItem(id: "deco_adventurepack", name: "探险背包", iconName: "backpack.fill", category: .backpack, levelRequired: 10, description: "准备好去更远的地方了吗？"),
        DecorationItem(id: "deco_sportsbag", name: "运动包", iconName: "bag.fill", category: .backpack, levelRequired: 12, description: "装满运动装备。"),
        DecorationItem(id: "deco_crown", name: "金色皇冠", iconName: "crown.fill", category: .hat, levelRequired: 15, description: "健康之王的象征。"),
        DecorationItem(id: "deco_nighttheme", name: "星空主题", iconName: "moon.stars.fill", category: .theme, levelRequired: 18, description: "夜晚的宁静。"),
        DecorationItem(id: "deco_star", name: "明星徽章", iconName: "star.circle.fill", category: .accessory, levelRequired: 20, description: "只有真正的健康达人才能获得。"),
    ]
    
    static func forLevel(_ level: Int) -> [DecorationItem] {
        all.filter { $0.levelRequired <= level }
    }
    
    static func find(by id: String) -> DecorationItem? {
        all.first { $0.id == id }
    }
    
    static func items(in category: DecorationItem.DecorationCategory) -> [DecorationItem] {
        all.filter { $0.category == category }
    }
}
