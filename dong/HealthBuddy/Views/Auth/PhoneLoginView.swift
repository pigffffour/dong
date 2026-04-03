import SwiftUI

struct PhoneLoginView: View {
    @EnvironmentObject private var authService: AuthService
    @State private var phoneNumber = ""
    @State private var showSMSCode = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xF7F5F2)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("🐻")
                    .font(.system(size: 80))
                
                Text("健康伙伴")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                    .padding(.top, 12)
                
                Text("用手机号登录，开启健康之旅")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                    .padding(.top, 4)
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Text("+86")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        
                        TextField("请输入手机号", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        sendCode()
                    } label: {
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("获取验证码")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            phoneNumber.count == 11
                            ? Color(hex: 0x6B5CE7)
                            : Color(hex: 0xB0AAC0),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                        .foregroundStyle(.white)
                    }
                    .disabled(phoneNumber.count != 11 || isLoading)
                }
                .padding(.horizontal, 28)
                .padding(.top, 40)
                
                Spacer()
                Spacer()
            }
        }
        .navigationDestination(isPresented: $showSMSCode) {
            SMSCodeView(phoneNumber: phoneNumber)
        }
    }
    
    private func sendCode() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.sendSMSCode(to: phoneNumber)
                showSMSCode = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
