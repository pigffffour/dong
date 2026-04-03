import SwiftUI
import Charts

struct BuilderOnboardingFlow: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack {
            switch appState.onboardingStep {
            case .welcome:
                BuilderWelcomeScreen()
            case .perm1:
                BuilderPermissionScreen(
                    step: 1,
                    title: "读取健康数据",
                    emoji: "🐻📓",
                    description: "需要读取你的运动与睡眠数据，用于计算小熊的能量槽与心情状态。",
                    note: "你的数据只在本地运算，绝不上传服务器",
                    primaryCTA: "去授权 HealthKit",
                    onPrimary: { appState.onboardingStep = .perm2 },
                    secondaryCTA: "稍后再说",
                    onSecondary: { appState.onboardingStep = .perm2 }
                )
            case .perm2:
                BuilderPermissionScreen(
                    step: 2,
                    title: "使用相机与相册",
                    emoji: "🐻📸",
                    description: "拍照识别食物，帮小熊记录每餐，让它知道你吃了什么、补充了多少能量。",
                    note: "照片仅用于本次识别，不存储到任何服务器",
                    primaryCTA: "去授权相机",
                    onPrimary: { appState.onboardingStep = .perm3 },
                    secondaryCTA: "稍后再说",
                    onSecondary: { appState.onboardingStep = .perm3 }
                )
            case .perm3:
                BuilderPermissionScreen(
                    step: 3,
                    title: "接收提醒通知",
                    emoji: "🐻🔔",
                    description: "让小熊在合适的时机轻轻提醒你——该走走了、该喝水了，或者睡眠时间到啦。",
                    note: "小熊只在有意义的时候打扰你",
                    primaryCTA: "开启提醒",
                    onPrimary: { appState.onboardingStep = .create },
                    secondaryCTA: "不需要",
                    onSecondary: { appState.onboardingStep = .create }
                )
            case .create:
                BuilderCreateBuddyScreen()
            }
        }
    }
}

struct BuilderWelcomeScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xFBF6EC), Color(hex: 0xEEE8FA), Color(hex: 0xE4F3FC)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(LinearGradient(colors: [Color(hex: 0xB99FE8), Color(hex: 0x7CC4E8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 84, height: 84)
                            .shadow(color: Color(hex: 0xB99FE8).opacity(0.38), radius: 20, x: 0, y: 10)
                        Text("🐻")
                            .font(.system(size: 44))
                    }
                    
                    VStack(spacing: 4) {
                        Text("Builder")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                        Text("健康伙伴")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color(hex: 0xB99FE8))
                            .tracking(2.5)
                    }
                    
                    Text("🐻")
                        .font(.system(size: 130))
                        .scaleEffect(1.02)
                        .modifier(Breathe())
                        .onTapGesture { appState.onboardingStep = .perm1 }
                    
                    Text("你将拥有一只小熊伙伴\n健康习惯会让它更有精神")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(hex: 0x5A5570))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    HStack(spacing: 8) {
                        Dot(active: false)
                        Dot(active: false)
                        Dot(active: true)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                Button {
                    appState.onboardingStep = .perm1
                } label: {
                    Text("开始 →")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryGradientButtonStyle())
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
    }
}

struct BuilderPermissionScreen: View {
    let step: Int
    let title: String
    let emoji: String
    let description: String
    let note: String
    let primaryCTA: String
    let onPrimary: () -> Void
    let secondaryCTA: String
    let onSecondary: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xF7F5F2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        StepDot(on: step == 1)
                        StepDot(on: step == 2)
                        StepDot(on: step == 3)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                VStack(spacing: 14) {
                    Text(emoji)
                        .font(.system(size: 96))
                        .modifier(Breathe())
                    
                    Text(title)
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                        .multilineTextAlignment(.center)
                    
                    Text(description)
                        .font(.system(size: 14.5))
                        .foregroundStyle(Color(hex: 0x6A6480))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    HStack(spacing: 8) {
                        Text("🔒")
                        Text(note)
                    }
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x4A9E6E))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0x6BC98F).opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.top, 4)
                }
                .padding(.horizontal, 36)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Button(action: onPrimary) {
                        Text(primaryCTA)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryGradientButtonStyle())
                    
                    Button(action: onSecondary) {
                        Text(secondaryCTA)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GhostButtonStyle())
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
    }
}

struct BuilderCreateBuddyScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @State private var name: String = "小熊"
    @State private var skin: String = "🐻"
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xFDF7EE), Color(hex: 0xF7F5F2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("为你的伙伴\n取个名字吧 🐻")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                        .lineSpacing(3)
                    Text("它会陪你一起养成健康习惯")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 18)
                
                Text(skin)
                    .font(.system(size: 110))
                    .modifier(Breathe())
                    .padding(.vertical, 12)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("伙伴名字")
                        .font(.system(size: 11.5, weight: .bold))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                        .tracking(0.8)
                        .textCase(.uppercase)
                    
                    TextField("", text: $name)
                        .textFieldStyle(CreateInputStyle())
                    
                    Text("选择外观")
                        .font(.system(size: 11.5, weight: .bold))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                        .tracking(0.8)
                        .textCase(.uppercase)
                        .padding(.top, 8)
                    
                    HStack(spacing: 12) {
                        SkinOption(emoji: "🐻", selected: skin == "🐻") { skin = "🐻" }
                        SkinOption(emoji: "🐨", selected: skin == "🐨") { skin = "🐨" }
                        SkinOption(emoji: "🧸", selected: skin == "🧸") { skin = "🧸" }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button {
                    appState.buddy.name = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "小熊" : name.trimmingCharacters(in: .whitespacesAndNewlines)
                    appState.onboardingCompleted = true
                } label: {
                    Text("进入我的伙伴 →")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryGradientButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct BuilderMainShell: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appState.selectedTab {
                case .buddy:
                    BuilderHomeScreen()
                case .record:
                    BuilderFoodCameraScreen()
                case .explore:
                    BuilderMapScreen()
                case .profile:
                    BuilderProfileScreen()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BuilderBottomNav(selected: $appState.selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BuilderBottomNav: View {
    @Binding var selected: BuilderAppState.Tab
    
    var body: some View {
        HStack {
            TabItem(tab: .buddy, selected: $selected, icon: "🏠", label: "伙伴")
            TabItem(tab: .record, selected: $selected, icon: "📷", label: "记录")
            TabItem(tab: .explore, selected: $selected, icon: "🗺️", label: "探索")
            TabItem(tab: .profile, selected: $selected, icon: "👤", label: "我的")
        }
        .padding(.top, 10)
        .padding(.bottom, 22)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .overlay(Rectangle().fill(Color.black.opacity(0.06)).frame(height: 1), alignment: .top)
    }
}

struct TabItem: View {
    let tab: BuilderAppState.Tab
    @Binding var selected: BuilderAppState.Tab
    let icon: String
    let label: String
    
    var body: some View {
        Button {
            selected = tab
        } label: {
            VStack(spacing: 3) {
                Text(icon)
                    .font(.system(size: 23))
                    .opacity(selected == tab ? 1 : 0.35)
                Text(label)
                    .font(.system(size: 10.5, weight: selected == tab ? .bold : .medium))
                    .foregroundStyle(selected == tab ? Color(hex: 0x6B5CE7) : Color(hex: 0x9A95A8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct BuilderHomeScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @State private var showDialog: Bool = false
    @State private var showStatus: Bool = false
    @State private var showExercise: Bool = false
    @State private var showSleep: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xE5F2FF), Color(hex: 0xEEE6FF), Color(hex: 0xFDF7EE)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Pill(text: "📍 \(currentMapName)")
                        Spacer()
                        Pill(text: "☀️ 22°C 晴")
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 54)
                    
                    ZStack {
                        Circle()
                            .fill(moodGlowColor.opacity(0.28))
                            .frame(width: 200, height: 200)
                            .scaleEffect(1.02)
                            .modifier(GlowPulse())
                        
                        VStack(spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                Text("🐻")
                                    .font(.system(size: 124))
                                    .modifier(Breathe(strength: 0.06, duration: 4))
                                    .onTapGesture { showDialog.toggle() }
                                    .padding(.top, 4)
                                
                                if showDialog {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("今天能量还不错！\n去走走步会更好哦 🌿")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color(hex: 0x1E1B2E))
                                            .lineSpacing(4)
                                        Text("💡 点击查看今日建议")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundStyle(Color(hex: 0xB99FE8))
                                    }
                                    .padding(.vertical, 11)
                                    .padding(.horizontal, 15)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.black.opacity(0.05), lineWidth: 1))
                                    .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 4)
                                    .transition(.scale.combined(with: .opacity))
                                    .offset(x: 8, y: -14)
                                    .onTapGesture { showStatus = true }
                                }
                            }
                            
                            Text("😊 状态：\(moodText)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: 0x5A5570))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
                                .padding(.top, -12)
                        }
                    }
                    .frame(height: 260)
                    .padding(.top, 10)
                    
                    VStack(spacing: 14) {
                        Button {
                            showStatus = true
                        } label: {
                            BuilderEnergyCard(value: energyValue)
                        }
                        .buttonStyle(.plain)
                        
                        VStack(alignment: .leading, spacing: 11) {
                            Text("今日行动")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                            
                            VStack(spacing: 10) {
                                BuilderActionRow(
                                    icon: "🏃",
                                    iconBg: Color(hex: 0xEAFAF1),
                                    title: "动一动",
                                    subtitle: "今日 6,024 步，目标 10,000",
                                    progress: 0.60,
                                    trailing: .arrow
                                ) { showExercise = true }
                                
                                BuilderActionRow(
                                    icon: "🌙",
                                    iconBg: Color(hex: 0xEAF2FF),
                                    title: "睡得好",
                                    subtitle: "昨晚 7.5 小时 · 不错",
                                    progress: nil,
                                    trailing: .check
                                ) { showSleep = true }
                            }
                        }
                        
                        BuilderDietTimelineCard()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 110)
                }
            }
        }
        .navigationDestination(isPresented: $showStatus) {
            BuilderTodayStatusScreen()
        }
        .navigationDestination(isPresented: $showExercise) {
            BuilderExerciseScreen()
        }
        .navigationDestination(isPresented: $showSleep) {
            BuilderSleepScreen()
        }
    }
    
    private var currentMapName: String {
        appState.buddy.currentMap?.name ?? "青青草原"
    }
    
    private var moodText: String {
        switch appState.buddy.mood {
        case .happy: return "开心"
        case .normal: return "平常"
        case .tired: return "疲惫"
        case .hungry: return "饥饿"
        }
    }
    
    private var moodGlowColor: Color {
        switch appState.buddy.mood {
        case .happy: return Color(hex: 0x6BC98F)
        case .normal: return Color(hex: 0x7CC4E8)
        case .tired: return Color(hex: 0xF5C842)
        case .hungry: return Color(hex: 0xF07B5A)
        }
    }
    
    private var energyValue: Int {
        Int((appState.buddy.energy * 100).rounded())
    }
}

struct BuilderFoodCameraScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack {
            Color(hex: 0x101020).ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Button {
                        appState.selectedTab = .buddy
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.white.opacity(0.14))
                            Text("←")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 38, height: 38)
                    }
                    .buttonStyle(.plain)
                    
                    Text("拍照识别")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)
                
                ZStack {
                    RadialGradient(colors: [Color(hex: 0x1E2040), Color(hex: 0x0D0E1A)], center: .center, startRadius: 20, endRadius: 380)
                        .ignoresSafeArea()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 270, height: 270)
                        
                        BuilderScanLine()
                            .frame(width: 270, height: 270)
                        
                        BuilderCornerMarks()
                            .frame(width: 270, height: 270)
                    }
                    
                    VStack {
                        Spacer()
                        Text("🐻🔍 将食物放入框内，小熊帮你识别")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.white.opacity(0.55))
                            .padding(.bottom, 28)
                    }
                }
                .frame(maxHeight: .infinity)
                
                HStack(spacing: 28) {
                    Button { appState.showFoodLoading = true } label: {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 56, height: 56)
                            .overlay(Text("🖼️").font(.system(size: 26)))
                    }
                    .buttonStyle(.plain)
                    
                    Button { appState.showFoodLoading = true } label: {
                        Circle()
                            .fill(Color.white.opacity(0.95))
                            .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 4))
                            .frame(width: 76, height: 76)
                            .shadow(color: Color.white.opacity(0.18), radius: 24, x: 0, y: 4)
                            .overlay(Text("📷").font(.system(size: 30)))
                    }
                    .buttonStyle(.plain)
                    
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 56, height: 56)
                        .overlay(Text("⚡").font(.system(size: 26)))
                        .opacity(0.45)
                }
                .padding(.bottom, 110)
            }
            
        }
        .navigationDestination(isPresented: $appState.showFoodLoading) {
            BuilderFoodLoadingScreen()
        }
    }
}

struct BuilderFoodLoadingScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xFDF6EC), Color(hex: 0xF3EEFF)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    Text("🐻🔍")
                        .font(.system(size: 90))
                        .modifier(Bounce())
                    Text("小熊正在识别…")
                        .font(.system(size: 23, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                        .padding(.top, 10)
                    Text("分析食物成分与热量")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                    HStack(spacing: 9) {
                        LoadingDot(delay: 0)
                        LoadingDot(delay: 0.22)
                        LoadingDot(delay: 0.44)
                    }
                    .padding(.top, 22)
                }
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    appState.showFoodResults = true
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $appState.showFoodResults) {
            BuilderFoodResultsScreen()
        }
    }
}

struct BuilderFoodResultsScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Int = 0
    
    private let foods: [BuilderFood] = [
        BuilderFood(emoji: "🍜", name: "番茄蛋花汤面", detail: "约 420 kcal · 碳水 65g · 蛋白 14g", stars: 5, energyBonus: 12),
        BuilderFood(emoji: "🍝", name: "素炒面", detail: "约 380 kcal · 碳水 58g · 蛋白 9g", stars: 4, energyBonus: 10),
        BuilderFood(emoji: "🍲", name: "其他面食", detail: "约 350 kcal · 碳水 52g · 蛋白 8g", stars: 3, energyBonus: 8)
    ]
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7F5F2).ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    LinearGradient(colors: [Color(hex: 0xFFD67A), Color(hex: 0xFF9F5A)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 200)
                        .overlay(Text("🍜").font(.system(size: 80)))
                    
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.28))
                            Text("←")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 38, height: 38)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 56)
                    .padding(.leading, 18)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("识别结果")
                            .font(.system(size: 21, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                        Text("选择一个喂给小熊 🐻")
                            .font(.system(size: 13.5))
                            .foregroundStyle(Color(hex: 0x9A95A8))
                    }
                    .padding(.top, 22)
                    .padding(.horizontal, 22)
                    
                    VStack(spacing: 0) {
                        ForEach(Array(foods.enumerated()), id: \.offset) { idx, item in
                            BuilderFoodRow(item: item, selected: selected == idx)
                                .onTapGesture { selected = idx }
                                .padding(.horizontal, selected == idx ? 14 : 22)
                                .padding(.vertical, 13)
                                .background(selected == idx ? Color(hex: 0xF5EFFF) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .padding(.horizontal, selected == idx ? 8 : 0)
                        }
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 10) {
                        Button {
                            appState.selectedFoodEnergyBonus = foods[selected].energyBonus
                            appState.showFeedResult = true
                        } label: {
                            Text("🐻 喂给小熊！")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(GreenButtonStyle())
                        
                        Button {
                            appState.selectedTab = .buddy
                        } label: {
                            Text("✏️ 没识别对？手动搜索")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(hex: 0xB99FE8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.top, -26)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $appState.showFeedResult) {
            BuilderFeedResultScreen()
        }
    }
}

struct BuilderFeedResultScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @State private var appliedEnergyValue: Int = 0

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xE5FFF1), Color(hex: 0xF3EEFF)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 18) {
                    Text("🐻")
                        .font(.system(size: 120))
                        .modifier(HappyJump())

                    VStack(spacing: 4) {
                        Text("⚡ +\(appState.selectedFoodEnergyBonus)")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: 0x6BC98F))
                        Text("能量值已补充")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(hex: 0x9A95A8))
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 36)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: Color.black.opacity(0.07), radius: 22, x: 0, y: 4)

                    Text("\"好香！我感觉更有力气了～\n谢谢你喂我！🌟\"")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)

                    BuilderMiniEnergyCard(value: appliedEnergyValue)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 28)

                Spacer()

                Button {
                    appState.showFeedResult = false
                    appState.showFoodResults = false
                    appState.showFoodLoading = false
                    appState.selectedTab = .buddy
                } label: {
                    Text("回到首页 🏠")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(GreenButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            applyFeed()
        }
    }

    private func applyFeed() {
        let current = appState.buddy.energy
        let bonus = Double(appState.selectedFoodEnergyBonus) / 100.0
        appState.buddy.energy = min(1.0, current + bonus)
        appState.buddy.experience += 18
        if appState.buddy.experience >= 100 {
            appState.buddy.level += 1
            appState.buddy.experience = appState.buddy.experience.truncatingRemainder(dividingBy: 100)
            appState.buddy.checkUnlocks()
        }
        appState.buddy.mood = appState.buddy.energy >= 0.8 ? .happy : (appState.buddy.energy <= 0.25 ? .tired : .normal)
        appliedEnergyValue = Int((appState.buddy.energy * 100).rounded())
    }
}

struct BuilderDecorationScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @Environment(\.dismiss) private var dismiss
    @State private var tabIndex: Int = 0
    
    private let tabs = ["全部", "头饰", "配饰", "背包", "主题"]
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7F5F2).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack(spacing: 14) {
                        Button {
                            dismiss()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color.white)
                                Text("←")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color(hex: 0x1E1B2E))
                            }
                            .frame(width: 38, height: 38)
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                        
                        Text("装饰馆")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 54)
                    .padding(.bottom, 12)
                    
                    HStack(spacing: 16) {
                        ZStack(alignment: .top) {
                            Text("🐻")
                                .font(.system(size: 58))
                            if let deco = appState.buddy.currentDecoration {
                                Image(systemName: deco.iconName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color(hex: 0x6B5CE7))
                                    .offset(y: -10)
                            }
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(appState.buddy.currentDecoration?.name ?? "帅气绅士帽")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                            Text("当前穿戴 · Lv.\(appState.buddy.currentDecoration?.levelRequired ?? 3) 解锁")
                                .font(.system(size: 12.5))
                                .foregroundStyle(Color(hex: 0x9A95A8))
                            Text("更换外观 →")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color(hex: 0xB99FE8))
                                .padding(.top, 3)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(Array(tabs.enumerated()), id: \.offset) { idx, t in
                            Button {
                                tabIndex = idx
                            } label: {
                                VStack(spacing: 8) {
                                    Text(t)
                                        .font(.system(size: 13.5, weight: tabIndex == idx ? .bold : .medium))
                                        .foregroundStyle(tabIndex == idx ? Color(hex: 0x6B5CE7) : Color(hex: 0x9A95A8))
                                    Rectangle()
                                        .fill(tabIndex == idx ? Color(hex: 0x6B5CE7) : Color.clear)
                                        .frame(height: 2.5)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .background(Color.white)
                .overlay(Rectangle().fill(Color(hex: 0xF0ECE8)).frame(height: 1), alignment: .bottom)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(Buddy.allDecorations) { deco in
                            let unlocked = appState.buddy.unlockedDecorations.contains(deco)
                            let wearing = appState.buddy.currentDecoration == deco
                            Button {
                                if unlocked {
                                    appState.buddy.currentDecoration = wearing ? nil : deco
                                }
                            } label: {
                                VStack(spacing: 7) {
                                    ZStack {
                                        Circle()
                                            .fill(unlocked ? Color(hex: 0xF5EFFF) : Color.white)
                                            .frame(width: 46, height: 46)
                                        Image(systemName: deco.iconName)
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundStyle(unlocked ? Color(hex: 0x6B5CE7) : Color.black.opacity(0.25))
                                        if !unlocked {
                                            Text("🔒")
                                                .font(.system(size: 13))
                                                .opacity(0.55)
                                                .offset(x: 18, y: -18)
                                        }
                                    }
                                    Text(deco.name)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(Color(hex: 0x1E1B2E))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)
                                    
                                    if unlocked {
                                        Text(wearing ? "穿戴中" : "已解锁")
                                            .font(.system(size: 11, weight: wearing ? .bold : .regular))
                                            .foregroundStyle(wearing ? Color(hex: 0xB99FE8) : Color(hex: 0x9A95A8))
                                    } else {
                                        Text("Lv.\(deco.levelRequired) 解锁")
                                            .font(.system(size: 10.5))
                                            .foregroundStyle(Color(hex: 0xB0AAC0))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 10)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(wearing ? Color(hex: 0xB99FE8) : Color.clear, lineWidth: 2)
                                )
                                .opacity(unlocked ? 1 : 0.72)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 110)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BuilderMapScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7F5F2).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("探索地图")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    Text("解锁新场景，和小熊一起冒险")
                        .font(.system(size: 13.5))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.top, 54)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(Buddy.allMaps) { map in
                            BuilderMapCard(
                                map: map,
                                current: appState.buddy.currentMap == map,
                                unlocked: appState.buddy.unlockedMaps.contains(map)
                            ) {
                                if appState.buddy.unlockedMaps.contains(map) {
                                    appState.buddy.currentMap = map
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110)
                }
            }
        }
    }
}

// MARK: - 睡眠分析页面（参考 Pillow 风格）
struct BuilderSleepScreen: View {
    @Environment(\.dismiss) private var dismiss

    // 示例睡眠阶段数据
    private struct SleepPhase: Identifiable {
        let id = UUID()
        let start: Double   // 小时偏移（从 22:00 起算）
        let duration: Double // 小时
        let stage: Stage
        enum Stage: String { case awake = "清醒", rem = "REM", light = "浅睡", deep = "深睡" }

        var color: Color {
            switch stage {
            case .awake: return Color(hex: 0xF5C842)
            case .rem:   return Color(hex: 0xB99FE8)
            case .light: return Color(hex: 0x7CC4E8)
            case .deep:  return Color(hex: 0x3A6FC4)
            }
        }
        var yOrder: Int {
            switch stage { case .awake: return 0; case .rem: return 1; case .light: return 2; case .deep: return 3 }
        }
    }

    private let phases: [SleepPhase] = [
        .init(start: 0,    duration: 0.3,  stage: .awake),
        .init(start: 0.3,  duration: 0.5,  stage: .light),
        .init(start: 0.8,  duration: 0.7,  stage: .deep),
        .init(start: 1.5,  duration: 0.4,  stage: .rem),
        .init(start: 1.9,  duration: 0.8,  stage: .light),
        .init(start: 2.7,  duration: 1.0,  stage: .deep),
        .init(start: 3.7,  duration: 0.5,  stage: .rem),
        .init(start: 4.2,  duration: 1.0,  stage: .light),
        .init(start: 5.2,  duration: 0.6,  stage: .deep),
        .init(start: 5.8,  duration: 0.5,  stage: .rem),
        .init(start: 6.3,  duration: 0.8,  stage: .light),
        .init(start: 7.1,  duration: 0.4,  stage: .awake),
    ]

    // 本周睡眠时长
    private let weeklyHours: [(day: String, hours: Double)] = [
        ("周一", 7.2), ("周二", 6.5), ("周三", 8.1),
        ("周四", 7.5), ("周五", 7.5), ("周六", 9.0), ("周日", 6.8)
    ]

    // 心率数据
    private let heartRate: [(offset: Double, bpm: Int)] = [
        (0, 72), (0.5, 68), (1, 62), (1.5, 58), (2, 55),
        (2.5, 52), (3, 50), (3.5, 53), (4, 56), (4.5, 54),
        (5, 51), (5.5, 55), (6, 60), (6.5, 65), (7, 70)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1A1A2E), Color(hex: 0x16213E)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 导航栏
                HStack(spacing: 14) {
                    Button { dismiss() } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.white.opacity(0.12))
                            Text("←")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 38, height: 38)
                    }
                    .buttonStyle(.plain)

                    Text("睡眠分析")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()

                    Text("昨晚")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 睡眠评分
                        sleepScoreCard()

                        // 睡眠时长 & 时段
                        sleepDurationCard()

                        // 睡眠阶段图（Pillow 风格阶梯图）
                        sleepStagesCard()

                        // 睡眠心率曲线
                        sleepHeartRateCard()

                        // 本周睡眠趋势
                        weeklyTrendCard()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 睡眠评分
    @ViewBuilder
    private func sleepScoreCard() -> some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 8)
                    .frame(width: 90, height: 90)
                Circle()
                    .trim(from: 0, to: 0.82)
                    .stroke(
                        LinearGradient(colors: [Color(hex: 0x7CC4E8), Color(hex: 0xB99FE8)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("82")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    Text("分")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("睡眠质量不错")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text("深睡占比 28%，REM 正常\n入睡较快，中途未醒")
                    .font(.system(size: 12.5))
                    .lineSpacing(4)
                    .foregroundStyle(Color.white.opacity(0.6))
            }
            Spacer()
        }
        .padding(20)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - 时长 & 时段
    @ViewBuilder
    private func sleepDurationCard() -> some View {
        HStack(spacing: 0) {
            sleepStatItem(value: "7h 30m", label: "总时长", icon: "🛏️")
            sleepDivider()
            sleepStatItem(value: "22:30", label: "入睡", icon: "🌙")
            sleepDivider()
            sleepStatItem(value: "06:00", label: "醒来", icon: "☀️")
        }
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    @ViewBuilder
    private func sleepStatItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Text(icon).font(.system(size: 18))
            Text(value)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 10.5))
                .foregroundStyle(Color.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func sleepDivider() -> some View {
        Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 44)
    }

    // MARK: - 睡眠阶段阶梯图
    @ViewBuilder
    private func sleepStagesCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("睡眠阶段")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)

            // 图例
            HStack(spacing: 14) {
                ForEach(["清醒", "REM", "浅睡", "深睡"], id: \.self) { name in
                    let color: Color = {
                        switch name {
                        case "清醒": return Color(hex: 0xF5C842)
                        case "REM":  return Color(hex: 0xB99FE8)
                        case "浅睡": return Color(hex: 0x7CC4E8)
                        default:     return Color(hex: 0x3A6FC4)
                        }
                    }()
                    HStack(spacing: 4) {
                        Circle().fill(color).frame(width: 8, height: 8)
                        Text(name).font(.system(size: 10)).foregroundStyle(Color.white.opacity(0.5))
                    }
                }
            }

            // 阶梯图
            GeometryReader { geo in
                let w = geo.size.width
                let h: CGFloat = 120
                let totalHours: Double = 7.5
                let stageHeight = h / 4 // 4 stages

                ZStack(alignment: .topLeading) {
                    // 阶段色块
                    ForEach(phases) { phase in
                        let x = (phase.start / totalHours) * Double(w)
                        let bw = (phase.duration / totalHours) * Double(w)
                        let y = CGFloat(phase.yOrder) * stageHeight

                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(phase.color.opacity(0.85))
                            .frame(width: max(2, CGFloat(bw)), height: stageHeight - 2)
                            .offset(x: CGFloat(x), y: y)
                    }

                    // Y 轴标签
                    ForEach(Array(["清醒", "REM", "浅睡", "深睡"].enumerated()), id: \.offset) { i, label in
                        Text(label)
                            .font(.system(size: 9))
                            .foregroundStyle(Color.white.opacity(0.35))
                            .offset(x: -2, y: CGFloat(i) * stageHeight + stageHeight / 2 - 6)
                    }
                }
                .frame(height: h)
            }
            .frame(height: 120)

            // 时间轴
            HStack {
                Text("22:30").font(.system(size: 10)).foregroundStyle(Color.white.opacity(0.35))
                Spacer()
                Text("02:00").font(.system(size: 10)).foregroundStyle(Color.white.opacity(0.35))
                Spacer()
                Text("06:00").font(.system(size: 10)).foregroundStyle(Color.white.opacity(0.35))
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - 睡眠心率
    @ViewBuilder
    private func sleepHeartRateCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("❤️ 睡眠心率")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("平均 58 bpm")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white.opacity(0.45))
            }

            Chart(heartRate, id: \.offset) { item in
                LineMark(
                    x: .value("时间", item.offset),
                    y: .value("bpm", item.bpm)
                )
                .foregroundStyle(Color(hex: 0xF07B5A))
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("时间", item.offset),
                    y: .value("bpm", item.bpm)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0xF07B5A).opacity(0.25), Color(hex: 0xF07B5A).opacity(0)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: [0, 2, 4, 6]) { v in
                    AxisValueLabel {
                        if let h = v.as(Double.self) {
                            let hour = Int(22 + h) % 24
                            Text(String(format: "%02d:00", hour))
                                .font(.system(size: 9))
                                .foregroundStyle(Color.white.opacity(0.35))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [50, 60, 70]) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [3]))
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel()
                        .font(.system(size: 9))
                        .foregroundStyle(Color.white.opacity(0.35))
                }
            }
            .frame(height: 130)
        }
        .padding(18)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - 本周趋势
    @ViewBuilder
    private func weeklyTrendCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 本周睡眠")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("平均 7.5h")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white.opacity(0.45))
            }

            Chart(weeklyHours, id: \.day) { item in
                BarMark(
                    x: .value("日", item.day),
                    y: .value("小时", item.hours)
                )
                .foregroundStyle(
                    item.hours >= 7
                    ? Color(hex: 0x7CC4E8)
                    : Color(hex: 0xF5C842)
                )
                .cornerRadius(6)
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [6, 7, 8, 9]) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [3]))
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel()
                        .font(.system(size: 9))
                        .foregroundStyle(Color.white.opacity(0.35))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.system(size: 10))
                        .foregroundStyle(Color.white.opacity(0.45))
                }
            }
            .frame(height: 150)
        }
        .padding(18)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

// MARK: - 运动数据分析页面
struct BuilderExerciseScreen: View {
    @Environment(\.dismiss) private var dismiss

    // 示例数据（后续接入 HealthKit）
    private let weeklySteps: [(day: String, steps: Int)] = [
        ("周一", 8234), ("周二", 5120), ("周三", 11045),
        ("周四", 7800), ("周五", 6024), ("周六", 9300), ("周日", 4500)
    ]

    private let dailyCalories: [(hour: Int, kcal: Double)] = [
        (6, 12), (7, 35), (8, 68), (9, 45), (10, 82),
        (11, 55), (12, 120), (13, 40), (14, 95), (15, 60),
        (16, 110), (17, 75), (18, 130), (19, 50), (20, 30)
    ]

    private let weeklyDuration: [(day: String, minutes: Int)] = [
        ("周一", 42), ("周二", 18), ("周三", 65),
        ("周四", 35), ("周五", 28), ("周六", 55), ("周日", 15)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xEAFAF1), Color(hex: 0xF7F5F2)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 导航栏
                HStack(spacing: 14) {
                    Button { dismiss() } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.white)
                            Text("←")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                        }
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)

                    Text("动一动")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 今日概览
                        exerciseSummaryCard()

                        // 本周步数柱状图
                        chartCard(title: "🚶 本周步数") {
                            Chart(weeklySteps, id: \.day) { item in
                                BarMark(
                                    x: .value("日", item.day),
                                    y: .value("步数", item.steps)
                                )
                                .foregroundStyle(
                                    item.day == "周五"
                                    ? Color(hex: 0x6B5CE7)
                                    : Color(hex: 0xD4C8F5)
                                )
                                .cornerRadius(6)
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { value in
                                    AxisValueLabel {
                                        if let v = value.as(Int.self) {
                                            Text(v >= 1000 ? "\(v/1000)k" : "\(v)")
                                                .font(.system(size: 10))
                                                .foregroundStyle(Color(hex: 0x9A95A8))
                                        }
                                    }
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                                        .foregroundStyle(Color(hex: 0xE8E4F0))
                                }
                            }
                            .chartXAxis {
                                AxisMarks { value in
                                    AxisValueLabel()
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(hex: 0x9A95A8))
                                }
                            }
                            .frame(height: 180)
                        }

                        // 今日热量消耗折线图
                        chartCard(title: "🔥 今日热量消耗") {
                            Chart(dailyCalories, id: \.hour) { item in
                                LineMark(
                                    x: .value("时", item.hour),
                                    y: .value("kcal", item.kcal)
                                )
                                .foregroundStyle(Color(hex: 0x6BC98F))
                                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                                .interpolationMethod(.catmullRom)

                                AreaMark(
                                    x: .value("时", item.hour),
                                    y: .value("kcal", item.kcal)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: 0x6BC98F).opacity(0.3), Color(hex: 0x6BC98F).opacity(0.0)],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                            }
                            .chartXAxis {
                                AxisMarks(values: [6, 9, 12, 15, 18]) { value in
                                    AxisValueLabel {
                                        if let h = value.as(Int.self) {
                                            Text("\(h):00")
                                                .font(.system(size: 10))
                                                .foregroundStyle(Color(hex: 0x9A95A8))
                                        }
                                    }
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { _ in
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                                        .foregroundStyle(Color(hex: 0xE8E4F0))
                                    AxisValueLabel()
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(hex: 0x9A95A8))
                                }
                            }
                            .frame(height: 160)
                        }

                        // 本周运动时长柱状图
                        chartCard(title: "⏱️ 本周运动时长（分钟）") {
                            Chart(weeklyDuration, id: \.day) { item in
                                BarMark(
                                    x: .value("日", item.day),
                                    y: .value("分钟", item.minutes)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: 0x7CC4E8), Color(hex: 0xB5E8D0)],
                                        startPoint: .bottom, endPoint: .top
                                    )
                                )
                                .cornerRadius(6)
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { _ in
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                                        .foregroundStyle(Color(hex: 0xE8E4F0))
                                    AxisValueLabel()
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(hex: 0x9A95A8))
                                }
                            }
                            .chartXAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(hex: 0x9A95A8))
                                }
                            }
                            .frame(height: 160)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 今日概览卡片
    @ViewBuilder
    private func exerciseSummaryCard() -> some View {
        HStack(spacing: 0) {
            summaryItem(value: "6,024", unit: "步", label: "步数", color: Color(hex: 0x6B5CE7))
            divider()
            summaryItem(value: "280", unit: "kcal", label: "消耗", color: Color(hex: 0x6BC98F))
            divider()
            summaryItem(value: "28", unit: "min", label: "运动", color: Color(hex: 0x7CC4E8))
        }
        .padding(.vertical, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 3)
    }

    @ViewBuilder
    private func summaryItem(value: String, unit: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                Text(unit)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: 0x9A95A8))
            }
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func divider() -> some View {
        Rectangle()
            .fill(Color(hex: 0xF0ECE8))
            .frame(width: 1, height: 36)
    }

    // MARK: - 通用图表卡片容器
    @ViewBuilder
    private func chartCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(hex: 0x1E1B2E))
            content()
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 3)
    }
}

struct BuilderTodayStatusScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xF7F5F2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.white)
                            Text("←")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                        }
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    
                    Text("今日状态")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)
                
                Text("2026年3月30日 · 周一")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 14) {
                        BuilderRingsCard()
                            .padding(.horizontal, 20)
                        
                        HStack(alignment: .top, spacing: 13) {
                            Text("🐻")
                                .font(.system(size: 38))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("睡眠不错，运动稍少")
                                    .font(.system(size: 14, weight: .bold))
                                Text("昨晚睡得挺好，今天步数还差一点，饮食还没有记录哦～快去补充能量吧！")
                                    .font(.system(size: 13.5))
                                    .lineSpacing(4)
                            }
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 18)
                        .background(LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xE8F4FF)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("今日建议")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                                .padding(.horizontal, 22)
                            
                            VStack(spacing: 10) {
                                BuilderSuggestionRow(icon: "🚶", text: "散步 10 分钟，让小熊也动起来", reward: "⚡ +10")
                                BuilderSuggestionRow(icon: "📸", text: "记录今日饮食，小熊在等着吃饭", reward: "⚡ +12")
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        BuilderStreakCard()
                            .padding(.horizontal, 20)
                            .padding(.top, 4)
                    }
                    .padding(.bottom, 24)
                    .padding(.bottom, 110)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BuilderProfileScreen: View {
    @EnvironmentObject private var appState: BuilderAppState
    @EnvironmentObject private var authService: AuthService
    @State private var pushDecorations = false
    @State private var pushBodyData = false
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7F5F2).ignoresSafeArea()
            
            ScrollView {
                    VStack(spacing: 16) {
                        BuilderBearStatCard()
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        BuilderSettingsSection(
                            title: "授权管理",
                            rows: [
                                BuilderSettingsRow(icon: "❤️", label: "健康数据 HealthKit", trailing: .toggle(on: true)),
                                BuilderSettingsRow(icon: "📷", label: "相机与相册", trailing: .toggle(on: true)),
                                BuilderSettingsRow(icon: "🔔", label: "通知提醒", trailing: .toggle(on: true))
                            ]
                        )
                        .padding(.horizontal, 20)
                        
                        BuilderSettingsSection(
                            title: "小熊",
                            rows: [
                                BuilderSettingsRow(icon: "🎒", label: "装饰仓库", trailing: .value("9 件"), tap: { pushDecorations = true }),
                                BuilderSettingsRow(icon: "🏆", label: "成就徽章", trailing: .value("3 个")),
                                BuilderSettingsRow(icon: "🗺️", label: "地图探索", trailing: .value("\(appState.buddy.unlockedMaps.count) / \(Buddy.allMaps.count)"), tap: { appState.selectedTab = .explore })
                            ]
                        )
                        .padding(.horizontal, 20)
                        
                        BuilderSettingsSection(
                            title: "设置",
                            rows: [
                                BuilderSettingsRow(icon: "📏", label: "身体数据", trailing: .chevron, tap: { pushBodyData = true }),
                                BuilderSettingsRow(icon: "🎯", label: "目标设置", trailing: .chevron),
                                BuilderSettingsRow(icon: "🔒", label: "数据与隐私", trailing: .chevron),
                                BuilderSettingsRow(icon: "💬", label: "意见反馈", trailing: .chevron),
                                BuilderSettingsRow(icon: "ℹ️", label: "关于 Builder", trailing: .value("v0.1.0"))
                            ]
                        )
                        .padding(.horizontal, 20)
                        
                    }
                    .padding(.bottom, 110)
                    .navigationDestination(isPresented: $pushDecorations) {
                        BuilderDecorationScreen()
                    }
                    .navigationDestination(isPresented: $pushBodyData) {
                        BodyDataEditView(profile: authService.currentUser?.bodyProfile ?? BodyProfile())
                    }
                }
        }
    }
}

// MARK: - 今日饮食 U 型时间线卡片（数据驱动）
struct BuilderDietTimelineCard: View {
    @EnvironmentObject private var calorieManager: CalorieManager

    // 布局常量
    private let dotSpacing: CGFloat = 75   // 图标间固定距离
    private let rowHeight: CGFloat = 82    // 行高
    private let turnRadius: CGFloat = 18   // U 型弯圆角半径
    private let turnGap: CGFloat = 12      // 末尾图标到弯道起点的间距

    private var edgeMargin: CGFloat { turnRadius + turnGap + 5 }

    private var meals: [FoodRecord] { calorieManager.todayMeals }

    private func maxPerRow(width: CGFloat) -> Int {
        max(2, Int((width - 2 * edgeMargin) / dotSpacing) + 1)
    }

    private func rowCount(width: CGFloat) -> Int {
        guard !meals.isEmpty else { return 0 }
        return (meals.count - 1) / maxPerRow(width: width) + 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("🍽️ 今日饮食")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(calorieManager.totalCaloriesToday)")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    Text("kcal")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                }
            }

            if meals.isEmpty {
                HStack {
                    Spacer()
                    Text("还没有饮食记录")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: 0xB0ABBD))
                    Spacer()
                }
                .padding(.vertical, 16)
            } else {
                GeometryReader { geo in
                    let w = geo.size.width
                    let mpr = maxPerRow(width: w)
                    let positions = calcPositions(maxPerRow: mpr, width: w)

                    ZStack {
                        // 连接线：同行直线 + 圆角 U 型弯（图标不在弯道上）
                        buildPath(positions: positions, maxPerRow: mpr)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: 0xD4C8F5), Color(hex: 0xA8E8C0)],
                                    startPoint: .leading, endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                            )

                        // 餐点图标
                        ForEach(Array(meals.enumerated()), id: \.element.id) { i, meal in
                            if i < positions.count {
                                VStack(spacing: 3) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: 0xF5F0FF))
                                            .frame(width: 36, height: 36)
                                            .shadow(color: Color(hex: 0x6B5CE7).opacity(0.15), radius: 6, x: 0, y: 2)
                                        Text(meal.emoji)
                                            .font(.system(size: 17))
                                    }
                                    Text("\(Int(meal.calories)) kcal")
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(hex: 0x6B5CE7))
                                    Text(meal.foodName)
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(hex: 0x9A95A8))
                                }
                                .position(positions[i])
                            }
                        }
                    }
                    .clipped()
                }
                .frame(height: CGFloat(rowCount(width: 300)) * rowHeight)
            }
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 20)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 3)
    }

    // MARK: - 计算图标位置（固定间距，只在直线段上）
    private func calcPositions(maxPerRow mpr: Int, width: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        for i in 0..<meals.count {
            let row = i / mpr
            let col = i % mpr
            let isLTR = row % 2 == 0
            let slotX = edgeMargin + CGFloat(col) * dotSpacing
            let x = isLTR ? slotX : (width - slotX)
            let y = rowHeight / 2 + CGFloat(row) * rowHeight
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }

    // MARK: - 路径：直线段 + 间隔 + 圆角弯道
    private func buildPath(positions: [CGPoint], maxPerRow mpr: Int) -> Path {
        Path { path in
            guard positions.count > 1 else { return }
            path.move(to: positions[0])
            let r = turnRadius

            for i in 1..<positions.count {
                let prev = positions[i - 1]
                let curr = positions[i]
                let prevRow = (i - 1) / mpr
                let currRow = i / mpr

                if prevRow == currRow {
                    path.addLine(to: curr)
                } else {
                    // 先延伸 turnGap 到弯道起点，再画圆角 U 型弯
                    let turnsRight = prevRow % 2 == 0
                    if turnsRight {
                        let tx = prev.x + turnGap
                        path.addLine(to: CGPoint(x: tx, y: prev.y))
                        path.addArc(center: CGPoint(x: tx, y: prev.y + r),
                                     radius: r, startAngle: .degrees(-90),
                                     endAngle: .degrees(0), clockwise: false)
                        if curr.y - r > prev.y + r {
                            path.addLine(to: CGPoint(x: tx + r, y: curr.y - r))
                        }
                        path.addArc(center: CGPoint(x: tx, y: curr.y - r),
                                     radius: r, startAngle: .degrees(0),
                                     endAngle: .degrees(90), clockwise: false)
                        path.addLine(to: curr)
                    } else {
                        let tx = prev.x - turnGap
                        path.addLine(to: CGPoint(x: tx, y: prev.y))
                        path.addArc(center: CGPoint(x: tx, y: prev.y + r),
                                     radius: r, startAngle: .degrees(-90),
                                     endAngle: .degrees(-180), clockwise: true)
                        if curr.y - r > prev.y + r {
                            path.addLine(to: CGPoint(x: tx - r, y: curr.y - r))
                        }
                        path.addArc(center: CGPoint(x: tx, y: curr.y - r),
                                     radius: r, startAngle: .degrees(-180),
                                     endAngle: .degrees(-270), clockwise: true)
                        path.addLine(to: curr)
                    }
                }
            }
        }
    }
}

struct BuilderEnergyCard: View {
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text("⚡ 能量槽")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(value) ")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    Text("/ 100")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                }
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(hex: 0xF0ECE8))
                    .frame(height: 13)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LinearGradient(colors: [Color(hex: 0x6BC98F), Color(hex: 0xA8E8C0)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(0, CGFloat(value) / 100 * 320), height: 13)
                    .overlay(BuilderShine().clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)), alignment: .trailing)
                    .animation(.spring(response: 0.7, dampingFraction: 0.75), value: value)
            }
            
            Text(value >= 70 ? "状态不错，保持下去 💛 — 点击查看详情" : "有点累了，先补充能量吧 — 点击查看详情")
                .font(.system(size: 12.5))
                .foregroundStyle(Color(hex: 0x6A6480))
                .italic()
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 20)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 3)
    }
}

struct BuilderMiniEnergyCard: View {
    let value: Int
    
    var body: some View {
        VStack(spacing: 9) {
            HStack {
                Text("⚡ 能量槽")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                Spacer()
                Text("\(value) / 100")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color(hex: 0xF0ECE8))
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(colors: [Color(hex: 0x6BC98F), Color(hex: 0xA8E8C0)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(0, CGFloat(value) / 100 * 320), height: 10)
                    .animation(.spring(response: 0.7, dampingFraction: 0.75), value: value)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 2)
    }
}

struct BuilderActionRow: View {
    enum Trailing {
        case arrow
        case check
        case camera
    }
    
    let icon: String
    let iconBg: Color
    let title: String
    let subtitle: String
    let progress: Double?
    let trailing: Trailing
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 13) {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(iconBg)
                    .frame(width: 46, height: 46)
                    .overlay(Text(icon).font(.system(size: 23)))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    
                    if let progress {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(Color(hex: 0xF0ECE8))
                                .frame(height: 5)
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(LinearGradient(colors: [Color(hex: 0x6BC98F), Color(hex: 0xA8E8C0)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: max(0, CGFloat(progress) * 180), height: 5)
                        }
                    } else {
                        HStack(spacing: 3) {
                            Text("⭐⭐⭐⭐☆")
                                .font(.system(size: 15))
                        }
                    }
                    
                    Text(subtitle)
                        .font(.system(size: 11.5))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                BuilderTrailingBadge(kind: trailing)
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 15)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct BuilderTrailingBadge: View {
    let kind: BuilderActionRow.Trailing
    
    var body: some View {
        Group {
            switch kind {
            case .arrow:
                Circle()
                    .stroke(Color(hex: 0xE8E4F2), lineWidth: 2)
                    .frame(width: 30, height: 30)
                    .overlay(Text("→").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color(hex: 0x5A5570)))
            case .check:
                Circle()
                    .fill(Color(hex: 0x6BC98F))
                    .frame(width: 30, height: 30)
                    .overlay(Text("✓").font(.system(size: 14, weight: .bold)).foregroundStyle(.white))
            case .camera:
                Circle()
                    .fill(Color(hex: 0xFFF4EB))
                    .overlay(Circle().stroke(Color(hex: 0xF5C842), lineWidth: 2))
                    .frame(width: 30, height: 30)
                    .overlay(Text("📷").font(.system(size: 13)))
            }
        }
    }
}

struct BuilderCornerMarks: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let s: CGFloat = 26
            let t: CGFloat = 3
            
            Path { p in
                p.addPath(cornerPath(x: 0, y: 0, dx: 1, dy: 1, size: s))
                p.addPath(cornerPath(x: w, y: 0, dx: -1, dy: 1, size: s))
                p.addPath(cornerPath(x: 0, y: h, dx: 1, dy: -1, size: s))
                p.addPath(cornerPath(x: w, y: h, dx: -1, dy: -1, size: s))
            }
            .stroke(.white, style: StrokeStyle(lineWidth: t, lineCap: .round, lineJoin: .round))
        }
    }
    
    private func cornerPath(x: CGFloat, y: CGFloat, dx: CGFloat, dy: CGFloat, size: CGFloat) -> Path {
        Path { p in
            p.move(to: CGPoint(x: x, y: y + dy * size))
            p.addLine(to: CGPoint(x: x, y: y))
            p.addLine(to: CGPoint(x: x + dx * size, y: y))
        }
    }
}

struct BuilderScanLine: View {
    @State private var y: CGFloat = 8
    
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(LinearGradient(colors: [.clear, Color(hex: 0x6BC98F).opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing))
                .frame(height: 2)
                .position(x: geo.size.width / 2, y: y)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false)) {
                        y = geo.size.height - 10
                    }
                }
        }
        .clipped()
    }
}

struct BuilderFoodRow: View {
    let item: BuilderFood
    let selected: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Text(item.emoji)
                .font(.system(size: 38))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                Text(item.detail)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color(hex: 0x9A95A8))
            }
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    Text("★")
                        .font(.system(size: 13))
                        .foregroundStyle(i < item.stars ? Color(hex: 0xF5C842) : Color(hex: 0xE0DBD5))
                }
            }
        }
    }
}

struct BuilderFood: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let detail: String
    let stars: Int
    let energyBonus: Int
}

struct BuilderMapCard: View {
    let map: MapItem
    let current: Bool
    let unlocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(background)
                    .frame(height: 172)
                    .shadow(color: Color.black.opacity(0.12), radius: 26, x: 0, y: 6)
                
                VStack(alignment: .leading, spacing: 2) {
                    Spacer()
                    Text(map.name)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Text(map.description)
                        .font(.system(size: 12.5))
                        .foregroundStyle(Color.white.opacity(0.85))
                        .lineLimit(2)
                        .padding(.top, 2)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.white.opacity(0.25))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color(hex: 0x6BC98F))
                            .frame(width: current ? 220 : 110, height: 4)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 14)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .background(LinearGradient(colors: [.clear, Color.black.opacity(0.62)], startPoint: .top, endPoint: .bottom), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                
                Text(badgeText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 11)
                    .background(badgeBg, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.28), lineWidth: 1))
                    .padding(.top, 12)
                    .padding(.trailing, 14)
                
                if !unlocked {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(hex: 0x141223).opacity(0.52))
                        VStack(spacing: 6) {
                            Text("🔒")
                                .font(.system(size: 32))
                            Text("达到 Lv.\(map.levelRequired) 解锁")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            Text("当前 Lv.\(map.levelRequired - 2) · 还差 2 级")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.white.opacity(0.75))
                        }
                    }
                    .frame(height: 172)
                }
            }
        }
        .buttonStyle(.plain)
        .opacity(unlocked ? 1 : 1)
    }
    
    private var badgeText: String {
        if current { return "📍 正在这里" }
        if unlocked { return "✅ 已解锁" }
        return "🔒 未解锁"
    }
    
    private var badgeBg: Color {
        if current { return Color(hex: 0x6BC98F).opacity(0.75) }
        return Color.white.opacity(0.18)
    }
    
    private var background: LinearGradient {
        switch map.name {
        case "青青草原":
            return LinearGradient(colors: [Color(hex: 0x5CB87A), Color(hex: 0x9EDFB4)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "静谧森林":
            return LinearGradient(colors: [Color(hex: 0x5AADE0), Color(hex: 0x94D4F5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "落日海滩":
            return LinearGradient(colors: [Color(hex: 0xE8A038), Color(hex: 0xF5C850)], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: 0x3A3880), Color(hex: 0x7A5AAA)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct BuilderRingsCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("今日能量来源")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(hex: 0x1E1B2E))
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                RingItem(icon: "🌙", label: "睡眠", color: Color(hex: 0x7CC4E8), progress: 0.75)
                Spacer()
                RingItem(icon: "🏃", label: "运动", color: Color(hex: 0x6BC98F), progress: 0.60)
                Spacer()
                RingItem(icon: "🍎", label: "饮食", color: Color(hex: 0xF5C842), progress: 0.25)
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 3)
    }
}

struct RingItem: View {
    let icon: String
    let label: String
    let color: Color
    let progress: Double
    
    var body: some View {
        VStack(spacing: 9) {
            ZStack {
                Circle()
                    .stroke(Color(hex: 0xF0ECE8), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(icon)
                    .font(.system(size: 20))
            }
            .frame(width: 68, height: 68)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: 0x9A95A8))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(color)
        }
    }
}

struct BuilderSuggestionRow: View {
    let icon: String
    let text: String
    let reward: String
    
    var body: some View {
        HStack(spacing: 13) {
            Text(icon)
                .font(.system(size: 28))
            Text(text)
                .font(.system(size: 13.5))
                .foregroundStyle(Color(hex: 0x1E1B2E))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(reward)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color(hex: 0x6BC98F))
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 15)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct BuilderStreakCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🔥 连续打卡")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                Spacer()
                Text("5 天")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: 0xF5C842))
            }
            HStack(spacing: 6) {
                StreakDot(style: .done)
                StreakDot(style: .done)
                StreakDot(style: .done)
                StreakDot(style: .done)
                StreakDot(style: .done)
                StreakDot(style: .today)
                StreakDot(style: .empty)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct StreakDot: View {
    enum Style {
        case done
        case today
        case empty
    }
    
    let style: Style
    
    var body: some View {
        let text: String
        let bg: Color
        let fg: Color
        
        switch style {
        case .done:
            text = "✓"
            bg = Color(hex: 0xF5C842)
            fg = .white
        case .today:
            text = "今"
            bg = Color(hex: 0x6BC98F)
            fg = .white
        case .empty:
            text = ""
            bg = Color(hex: 0xF0ECE8)
            fg = .clear
        }
        
        return Text(text)
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 34, height: 34)
            .background(bg, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            .foregroundStyle(fg)
    }
}

struct BuilderBearStatCard: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .top) {
                Text("🐻")
                    .font(.system(size: 50))
                Text("🎩")
                    .font(.system(size: 22))
                    .offset(y: -6)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("小熊 · Lv.3")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                Text("经验值 650 / 1000")
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color(hex: 0xF0ECE8))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(LinearGradient(colors: [Color(hex: 0xB99FE8), Color(hex: 0x7CC4E8)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 0.65 * 180, height: 6)
                }
                .padding(.top, 7)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("能量")
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                Text("72")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: 0x6BC98F))
            }
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.10), radius: 24, x: 0, y: 6)
    }
}

struct BuilderSettingsSection: View {
    let title: String
    let rows: [BuilderSettingsRow]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(Color(hex: 0x9A95A8))
                .tracking(0.8)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { idx, row in
                    row
                    if idx != rows.count - 1 {
                        Divider()
                            .overlay(Color(hex: 0xF5F1EC))
                            .padding(.leading, 16)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        }
    }
}

struct BuilderSettingsRow: View {
    enum Trailing {
        case chevron
        case value(String)
        case toggle(on: Bool)
        case none
    }
    
    let icon: String
    let label: String
    let trailing: Trailing
    var tap: (() -> Void)? = nil
    
    var body: some View {
        Button {
            tap?()
        } label: {
            HStack(spacing: 14) {
                Text(icon)
                    .font(.system(size: 20))
                    .frame(width: 30)
                
                Text(label)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                
                Spacer()
                
                trailingView
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(tap == nil)
    }
    
    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .chevron:
            Text("›")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(hex: 0xC8C4D0))
        case .value(let v):
            HStack(spacing: 8) {
                Text(v)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                Text("›")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(hex: 0xC8C4D0))
            }
        case .toggle(let on):
            ZStack(alignment: on ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(on ? Color(hex: 0x6BC98F) : Color.black.opacity(0.12))
                    .frame(width: 48, height: 28)
                Circle()
                    .fill(Color.white)
                    .frame(width: 22, height: 22)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 1)
                    .padding(.horizontal, 3)
            }
        case .none:
            EmptyView()
        }
    }
}

struct Pill: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12.5))
            .foregroundStyle(Color(hex: 0x5A5570))
            .padding(.vertical, 6)
            .padding(.horizontal, 14)
            .background(Color.white.opacity(0.8), in: Capsule())
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 2)
    }
}

struct Dot: View {
    let active: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(Color(hex: 0xB99FE8).opacity(active ? 1 : 0.35))
            .frame(width: active ? 24 : 8, height: 8)
    }
}

struct StepDot: View {
    let on: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(on ? Color(hex: 0xB99FE8) : Color(hex: 0xDDD8F8))
            .frame(width: on ? 26 : 8, height: 8)
            .animation(.easeInOut(duration: 0.25), value: on)
    }
}

struct SkinOption: View {
    let emoji: String
    let selected: Bool
    let tap: () -> Void
    
    var body: some View {
        Button(action: tap) {
            Text(emoji)
                .font(.system(size: 42))
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(selected ? Color(hex: 0xB99FE8) : Color(hex: 0xEAE6E0), lineWidth: selected ? 2.5 : 2)
                )
                .shadow(color: selected ? Color(hex: 0xB99FE8).opacity(0.28) : Color.clear, radius: 18, x: 0, y: 4)
                .scaleEffect(selected ? 1.04 : 1)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: selected)
    }
}

struct PrimaryGradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(LinearGradient(colors: [Color(hex: 0xB99FE8), Color(hex: 0x7CC4E8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color(hex: 0xB99FE8).opacity(0.38), radius: 22, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct GreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(LinearGradient(colors: [Color(hex: 0x6BC98F), Color(hex: 0x4ABCB0)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color(hex: 0x6BC98F).opacity(0.35), radius: 22, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15))
            .foregroundStyle(Color(hex: 0x9A95A8))
            .frame(height: 48)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct CreateInputStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(.system(size: 17))
            .padding(.horizontal, 18)
            .frame(height: 54)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color(hex: 0xEAE6E0), lineWidth: 2))
    }
}

struct BuilderShine: View {
    @State private var x: CGFloat = -10
    
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(LinearGradient(colors: [.clear, Color.white.opacity(0.55)], startPoint: .leading, endPoint: .trailing))
                .frame(width: 28)
                .offset(x: x)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                        x = max(0, geo.size.width - 28)
                    }
                }
        }
    }
}

struct Breathe: ViewModifier {
    let strength: CGFloat
    let duration: Double
    @State private var on = false
    
    init(strength: CGFloat = 0.065, duration: Double = 3.5) {
        self.strength = strength
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(on ? (1 + strength) : 1)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: on)
            .onAppear { on = true }
    }
}

struct GlowPulse: ViewModifier {
    @State private var on = false
    
    func body(content: Content) -> some View {
        content
            .opacity(on ? 1 : 0.55)
            .scaleEffect(on ? 1.12 : 1)
            .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: on)
            .onAppear { on = true }
    }
}

struct Bounce: ViewModifier {
    @State private var on = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: on ? -18 : 0)
            .opacity(on ? 1 : 0.35)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: on)
            .onAppear { on = true }
    }
}

struct LoadingDot: View {
    let delay: Double
    @State private var on = false
    
    var body: some View {
        Circle()
            .fill(Color(hex: 0xB99FE8))
            .frame(width: 11, height: 11)
            .scaleEffect(on ? 1.25 : 0.7)
            .opacity(on ? 1 : 0.35)
            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(delay), value: on)
            .onAppear { on = true }
    }
}

struct HappyJump: ViewModifier {
    @State private var on = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(on ? 1 : 0.88)
            .animation(.easeOut(duration: 0.6), value: on)
            .onAppear { on = true }
    }
}

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

