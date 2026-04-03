import SwiftUI

/// 在个人资料中编辑身体数据
struct BodyDataEditView: View {
    @EnvironmentObject private var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var heightText: String
    @State private var weightText: String
    @State private var ageText: String
    @State private var selectedGender: BodyProfile.Gender?
    @State private var selectedActivity: BodyProfile.ActivityLevel
    
    init(profile: BodyProfile) {
        _heightText = State(initialValue: profile.heightCm.map { String(format: "%.0f", $0) } ?? "")
        _weightText = State(initialValue: profile.weightKg.map { String(format: "%.1f", $0) } ?? "")
        _ageText = State(initialValue: profile.age.map { String($0) } ?? "")
        _selectedGender = State(initialValue: profile.gender)
        _selectedActivity = State(initialValue: profile.activityLevel)
    }
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7F5F2).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
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
                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    
                    Text("身体数据")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(Color(hex: 0x1E1B2E))
                    
                    Spacer()
                    
                    Button("保存") { save() }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color(hex: 0x6B5CE7))
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        dataRow(title: "身高", unit: "cm", text: $heightText)
                        dataRow(title: "体重", unit: "kg", text: $weightText)
                        dataRow(title: "年龄", unit: "岁", text: $ageText)
                        
                        // 性别选择
                        VStack(alignment: .leading, spacing: 10) {
                            Text("性别")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color(hex: 0x9A95A8))
                            HStack(spacing: 12) {
                                ForEach(BodyProfile.Gender.allCases, id: \.self) { gender in
                                    Button {
                                        selectedGender = gender
                                    } label: {
                                        Text(gender.displayName)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(selectedGender == gender ? .white : Color(hex: 0x1E1B2E))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedGender == gender ? Color(hex: 0x6B5CE7) : Color.white,
                                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 活动水平
                        VStack(alignment: .leading, spacing: 10) {
                            Text("活动水平")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color(hex: 0x9A95A8))
                            ForEach(BodyProfile.ActivityLevel.allCases, id: \.self) { level in
                                Button {
                                    selectedActivity = level
                                } label: {
                                    HStack {
                                        Text(level.displayName)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color(hex: 0x1E1B2E))
                                        Spacer()
                                        if selectedActivity == level {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(Color(hex: 0x6B5CE7))
                                        }
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // BMI 显示
                        if let bmi = computedBMI {
                            HStack {
                                Text("BMI")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color(hex: 0x9A95A8))
                                Spacer()
                                Text(String(format: "%.1f", bmi))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color(hex: 0x6B5CE7))
                                Text(bmiCategory(bmi))
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color(hex: 0x9A95A8))
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func dataRow(title: String, unit: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(hex: 0x1E1B2E))
                .frame(width: 50, alignment: .leading)
            TextField("--", text: text)
                .keyboardType(.decimalPad)
                .font(.system(size: 16))
                .multilineTextAlignment(.trailing)
            Text(unit)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: 0x9A95A8))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 20)
    }
    
    private var computedBMI: Double? {
        guard let h = Double(heightText), let w = Double(weightText), h > 0 else { return nil }
        let hm = h / 100.0
        return w / (hm * hm)
    }
    
    private func bmiCategory(_ bmi: Double) -> String {
        if bmi < 18.5 { return "偏瘦" }
        if bmi < 25 { return "正常" }
        if bmi < 30 { return "偏胖" }
        return "肥胖"
    }
    
    private func save() {
        guard var user = authService.currentUser else { return }
        if let h = Double(heightText) { user.bodyProfile.heightCm = h }
        if let w = Double(weightText) { user.bodyProfile.weightKg = w }
        if let a = Int(ageText) { user.bodyProfile.age = a }
        user.bodyProfile.gender = selectedGender
        user.bodyProfile.activityLevel = selectedActivity
        user.updatedAt = Date()
        authService.updateUser(user)
        dismiss()
    }
}
