import SwiftUI

struct DecorationGalleryView: View {
    @ObservedObject var buddy: Buddy
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Buddy.allDecorations) { decoration in
                    let isUnlocked = buddy.unlockedDecorations.contains(decoration)
                    let isSelected = buddy.currentDecoration == decoration
                    
                    VStack {
                        ZStack {
                            Circle()
                                .fill(isUnlocked ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: decoration.iconName)
                                .font(.system(size: 40))
                                .foregroundColor(isUnlocked ? .blue : .gray)
                            
                            if !isUnlocked {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                    .offset(x: 30, y: 30)
                            }
                        }
                        
                        Text(decoration.name)
                            .font(.headline)
                        
                        if isUnlocked {
                            Button(isSelected ? "取消穿戴" : "穿戴") {
                                if isSelected {
                                    buddy.currentDecoration = nil
                                } else {
                                    buddy.currentDecoration = decoration
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(isSelected ? .red : .blue)
                        } else {
                            Text("等级 \(decoration.levelRequired) 解锁")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2))
                }
            }
            .padding()
        }
        .navigationTitle("装饰馆")
    }
}
