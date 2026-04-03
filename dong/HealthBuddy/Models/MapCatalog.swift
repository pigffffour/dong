import Foundation
import SwiftUI

struct MapItem: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let iconName: String
    let levelRequired: Int
    let description: String
    let gradientHexColors: [UInt32]
    
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum MapCatalog {
    static let all: [MapItem] = [
        MapItem(id: "map_grassland", name: "青青草原", iconName: "leaf.fill", levelRequired: 1, description: "一切开始的地方，空气非常清新。", gradientHexColors: [0x5CB87A, 0x9EDFB4]),
        MapItem(id: "map_forest", name: "静谧森林", iconName: "tree.fill", levelRequired: 5, description: "阳光穿过树叶，是散步的好去处。", gradientHexColors: [0x5AADE0, 0x94D4F5]),
        MapItem(id: "map_beach", name: "落日海滩", iconName: "beach.umbrella.fill", levelRequired: 10, description: "伴着夕阳在沙滩漫步吧。", gradientHexColors: [0xE8A038, 0xF5C850]),
        MapItem(id: "map_snowmountain", name: "雪山秘境", iconName: "snowflake", levelRequired: 15, description: "寒冷但壮观的雪景。", gradientHexColors: [0x88C8E8, 0xC0E0F0]),
        MapItem(id: "map_cloudpeak", name: "云端之巅", iconName: "cloud.fill", levelRequired: 20, description: "只有最健康的伙伴才能到达这里。", gradientHexColors: [0x3A3880, 0x7A5AAA]),
        MapItem(id: "map_volcano", name: "火山之心", iconName: "flame.fill", levelRequired: 25, description: "高温考验意志力。", gradientHexColors: [0xE05040, 0xF08050]),
        MapItem(id: "map_spacestation", name: "太空站", iconName: "sparkles", levelRequired: 30, description: "终极目标，遨游宇宙。", gradientHexColors: [0x1A1A40, 0x4040A0]),
    ]
    
    static func forLevel(_ level: Int) -> [MapItem] {
        all.filter { $0.levelRequired <= level }
    }
    
    static func find(by id: String) -> MapItem? {
        all.first { $0.id == id }
    }
}
