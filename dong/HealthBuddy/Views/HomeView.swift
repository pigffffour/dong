import SwiftUI

struct HomeView: View {
    @StateObject private var buddy = Buddy()
    @StateObject private var healthManager = HealthManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // 核心组件：小熊伙伴
                BuddyView(buddy: buddy)
                    .padding(.bottom, 50)
                
                // 核心组件：能量槽
                EnergyBar(energy: buddy.energy)
                    .padding(.bottom, 50)
                
                // 底部导航/功能按钮区（未来可以扩展跑步、地图、社交等）
                HStack(spacing: 40) {
                    NavigationLink(destination: CalorieRecognitionView(buddy: buddy)) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("拍照")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(Color.blue))
                    }
                    
                    NavigationLink(destination: DecorationGalleryView(buddy: buddy)) {
                        VStack {
                            Image(systemName: "tshirt.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("装饰")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(Color.purple))
                    }
                    
                    NavigationLink(destination: MapExplorationView(buddy: buddy)) {
                        VStack {
                            Image(systemName: "map.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("地图")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(Color.orange))
                    }
                }
                .padding(.bottom, 50)
            }
            .navigationTitle(buddy.currentMap?.name ?? "我的伙伴")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
        .onAppear {
            // 当页面出现时，更新小熊状态
            updateBuddyState()
        }
        .onChange(of: healthManager.currentStats.steps) {
            updateBuddyState()
        }
    }
    
    private func updateBuddyState() {
        let stats = healthManager.currentStats
        // 简单更新能量值（完整版通过 EnergyEngine 计算）
        buddy.energy = min(1.0, Double(stats.steps) / 10000.0)
        if buddy.energy > 0.8 && stats.sleepHours > 6.4 {
            buddy.mood = .happy
        } else if buddy.energy < 0.2 {
            buddy.mood = .tired
        } else {
            buddy.mood = .normal
        }
    }
}
