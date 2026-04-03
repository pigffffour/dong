import SwiftUI

/// 注册后收集身体数据（身高、体重、年龄、性别、活动水平）
struct BodyDataCollectionView: View {
    @EnvironmentObject private var authService: AuthService
    @Binding var isComplete: Bool
    
    @State private var heightText = ""
    @State private var weightText = ""
    @State private var ageText = ""
    @State private var selectedGender: BodyProfile.Gender?
    @State private var selectedActivity: BodyProfile.ActivityLevel = .lightlyActive
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xF7F5F2)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 进度条
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(i <= currentStep ? Color(hex: 0x6B5CE7) : Color(hex: 0xDDD8F0))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 60)
                
                Spacer()
                
                if currentStep == 0 {
                    stepBasicInfo
                } else if currentStep == 1 {
                    stepGender
                } else {
                    stepActivity
                }
                
                Spacer()
                
                // 底部按钮
                VStack(spacing: 12) {
                    Button {
                        advance()
                    } label: {
                        Text(currentStep == 2 ? "完成" : "下一步")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(canAdvance ? Color(hex: 0x6B5CE7) : Color(hex: 0xB0AAC0),
                                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .foregroundStyle(.white)
                    }
                    .disabled(!canAdvance)
                    
                    if currentStep < 2 {
                        Button("稍后再填") {
                            saveAndComplete()
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: 0x9A95A8))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Step 1: 身高/体重/年龄
    
    private var stepBasicInfo: some View {
        VStack(spacing: 24) {
            Text("🐻")
                .font(.system(size: 56))
            Text("基本身体数据")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(hex: 0x1E1B2E))
            Text("帮助小熊更了解你的健康目标")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: 0x9A95A8))
            
            VStack(spacing: 14) {
                bodyDataField(title: "身高 (cm)", text: $heightText, placeholder: "170")
                bodyDataField(title: "体重 (kg)", text: $weightText, placeholder: "65")
                bodyDataField(title: "年龄", text: $ageText, placeholder: "25")
            }
            .padding(.horizontal, 28)
        }
    }
    
    // MARK: - Step 2: 性别
    
    private var stepGender: some View {
        VStack(spacing: 24) {
            Text("基本身体数据")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(hex: 0x1E1B2E))
            Text("选择你的性别")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: 0x9A95A8))
            
            HStack(spacing: 16) {
                ForEach(BodyProfile.Gender.allCases, id: \.self) { gender in
                    Button {
                        selectedGender = gender
                    } label: {
                        VStack(spacing: 8) {
                            Text(genderEmoji(gender))
                                .font(.system(size: 40))
                            Text(gender.displayName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(hex: 0x1E1B2E))
                        }
                        .frame(width: 90, height: 100)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(selectedGender == gender ? Color(hex: 0x6B5CE7) : Color.clear, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Step 3: 活动水平
    
    private var stepActivity: some View {
        VStack(spacing: 24) {
            Text("你的日常活动水平")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(hex: 0x1E1B2E))
            
            VStack(spacing: 12) {
                ForEach(BodyProfile.ActivityLevel.allCases, id: \.self) { level in
                    Button {
                        selectedActivity = level
                    } label: {
                        HStack {
                            Text(activityEmoji(level))
                                .font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(level.displayName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color(hex: 0x1E1B2E))
                                Text(activityDescription(level))
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(hex: 0x9A95A8))
                            }
                            Spacer()
                            if selectedActivity == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color(hex: 0x6B5CE7))
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(selectedActivity == level ? Color(hex: 0x6B5CE7) : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 28)
        }
    }
    
    // MARK: - Helpers
    
    private var canAdvance: Bool {
        switch currentStep {
        case 0: return !heightText.isEmpty && !weightText.isEmpty && !ageText.isEmpty
        case 1: return selectedGender != nil
        case 2: return true
        default: return false
        }
    }
    
    private func advance() {
        if currentStep < 2 {
            withAnimation { currentStep += 1 }
        } else {
            saveAndComplete()
        }
    }
    
    private func saveAndComplete() {
        guard var user = authService.currentUser else { return }
        if let h = Double(heightText) { user.bodyProfile.heightCm = h }
        if let w = Double(weightText) { user.bodyProfile.weightKg = w }
        if let a = Int(ageText) { user.bodyProfile.age = a }
        user.bodyProfile.gender = selectedGender
        user.bodyProfile.activityLevel = selectedActivity
        user.updatedAt = Date()
        authService.updateUser(user)
        isComplete = true
    }
    
    private func bodyDataField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(hex: 0x9A95A8))
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
    
    private func genderEmoji(_ gender: BodyProfile.Gender) -> String {
        switch gender {
        case .male: return "👦"
        case .female: return "👧"
        case .other: return "🧑"
        }
    }
    
    private func activityEmoji(_ level: BodyProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "🪑"
        case .lightlyActive: return "🚶"
        case .moderatelyActive: return "🏃"
        case .veryActive: return "🏋️"
        }
    }
    
    private func activityDescription(_ level: BodyProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "办公室工作，很少运动"
        case .lightlyActive: return "每周轻度运动 1-3 天"
        case .moderatelyActive: return "每周中等强度运动 3-5 天"
        case .veryActive: return "每周高强度运动 6-7 天"
        }
    }
}
