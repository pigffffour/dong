import SwiftUI

struct MapExplorationView: View {
    @ObservedObject var buddy: Buddy
    
    var body: some View {
        List(Buddy.allMaps) { map in
            let isUnlocked = buddy.unlockedMaps.contains(map)
            let isSelected = buddy.currentMap == map
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isUnlocked ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: map.iconName)
                        .font(.title)
                        .foregroundColor(isUnlocked ? .green : .gray)
                    
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .offset(x: 20, y: 20)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(map.name)
                        .font(.headline)
                        .foregroundColor(isUnlocked ? .primary : .secondary)
                    
                    Text(map.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !isUnlocked {
                        Text("等级 \(map.levelRequired) 解锁")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                if isUnlocked {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Button("前往") {
                            buddy.currentMap = map
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("地图探索")
        .listStyle(.insetGrouped)
    }
}
