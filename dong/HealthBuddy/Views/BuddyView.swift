import SwiftUI

/// 小熊组件：根据状态改变表现
struct BuddyView: View {
    @ObservedObject var buddy: Buddy
    @State private var isPulsing = false
    
    var body: some View {
        VStack {
            ZStack {
                // 背景光晕，随心情改变颜色
                Circle()
                    .fill(moodColor.opacity(0.15))
                    .frame(width: 280, height: 280)
                    .blur(radius: 20)
                    .scaleEffect(isPulsing ? 1.1 : 0.95)
                    .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isPulsing)
                
                VStack {
                    ZStack {
                        // 伙伴动画区：Lottie 或 Mock
                        // 这里传入动画名称，例如: bear_happy, bear_tired 等
                        MockLottieView(name: "bear_\(buddy.mood.rawValue)")
                            .frame(width: 180, height: 180)
                        
                        // 动态展示当前佩戴的装饰品
                        if let decoration = buddy.currentDecoration {
                            Image(systemName: decoration.iconName)
                                .font(.system(size: 35))
                                .foregroundColor(.blue)
                                .shadow(radius: 2)
                                .offset(y: -60) // 假设帽子或饰品在头部上方
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    // 心情标签
                    Text(buddy.mood.rawValue)
                        .font(.system(.subheadline, design: .rounded).bold())
                        .foregroundColor(moodColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(color: moodColor.opacity(0.2), radius: 5, x: 0, y: 3)
                        )
                        .offset(y: -10)
                }
            }
            .onAppear {
                isPulsing = true
            }
            
            VStack(spacing: 4) {
                Text(buddy.name)
                    .font(.system(.title2, design: .rounded).bold())
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("等级 \(buddy.level)")
                        .font(.system(.subheadline, design: .rounded).bold())
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 10)
        }
    }
    
    private var moodColor: Color {
        switch buddy.mood {
        case .happy: return .green
        case .normal: return .blue
        case .tired: return .orange
        case .hungry: return .red
        }
    }
}

/// 精美能量槽 UI
struct EnergyBar: View {
    let energy: Double // 0.0 to 1.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label {
                    Text("当前能量状态")
                        .font(.system(.subheadline, design: .rounded).bold())
                } icon: {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                        .symbolEffect(.bounce, value: energy)
                }
                
                Spacer()
                
                Text("\(Int(energy * 100))%")
                    .font(.system(.caption, design: .monospaced).bold())
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            
            // 进度条背景
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.05), lineWidth: 1)
                    )
                
                // 进度条主体
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                energy > 0.3 ? .yellow : .red,
                                energy > 0.7 ? .green : .orange
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(28, CGFloat(energy) * 320), height: 28) // 基础宽度防止太窄
                    .shadow(color: (energy > 0.5 ? Color.green : Color.orange).opacity(0.3), radius: 5, x: 0, y: 3)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0), value: energy)
                
                // 玻璃高光效果
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0.4), .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 14)
                    .offset(y: -7)
                    .padding(.horizontal, 4)
            }
            .frame(width: 320)
            
            // 提示文案
            Text(energyHint)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.leading, 10)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
    
    private var energyHint: String {
        if energy > 0.8 { return "小熊能量满满，快带它去地图探索吧！" }
        if energy > 0.5 { return "能量很充沛，继续保持哦。" }
        if energy > 0.2 { return "小熊有点累了，需要补充运动或卡路里。" }
        return "警告：能量不足！小熊快跑不动了。"
    }
}
