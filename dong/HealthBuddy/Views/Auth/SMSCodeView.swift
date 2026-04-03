import SwiftUI
import Combine

struct SMSCodeView: View {
    let phoneNumber: String
    
    @EnvironmentObject private var authService: AuthService
    @State private var code = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var countdown = 60
    @State private var canResend = false
    @FocusState private var isFocused: Bool
    
    private let codeLength = 6
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xF3EEFF), Color(hex: 0xF7F5F2)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("🔐")
                    .font(.system(size: 56))
                
                Text("输入验证码")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: 0x1E1B2E))
                    .padding(.top, 12)
                
                Text("验证码已发送至 +86 \(phoneNumber)")
                    .font(.system(size: 13.5))
                    .foregroundStyle(Color(hex: 0x9A95A8))
                    .padding(.top, 4)
                
                // 验证码输入框
                HStack(spacing: 10) {
                    ForEach(0..<codeLength, id: \.self) { index in
                        let char = index < code.count
                            ? String(code[code.index(code.startIndex, offsetBy: index)])
                            : ""
                        Text(char)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: 0x1E1B2E))
                            .frame(width: 46, height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(index == code.count ? Color(hex: 0x6B5CE7) : Color.clear, lineWidth: 2)
                            )
                    }
                }
                .padding(.top, 32)
                .onTapGesture { isFocused = true }
                .overlay {
                    TextField("", text: $code)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                        .opacity(0.01)
                        .onChange(of: code) { _, newValue in
                            code = String(newValue.prefix(codeLength))
                            if code.count == codeLength {
                                verifyCode()
                            }
                        }
                }
                
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundStyle(.red)
                        .padding(.top, 12)
                }
                
                if isLoading {
                    ProgressView()
                        .padding(.top, 20)
                } else {
                    Button {
                        resendCode()
                    } label: {
                        if canResend {
                            Text("重新发送验证码")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(hex: 0x6B5CE7))
                        } else {
                            Text("\(countdown)s 后可重发")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(hex: 0x9A95A8))
                        }
                    }
                    .disabled(!canResend)
                    .padding(.top, 20)
                }
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 28)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { isFocused = true }
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                canResend = true
            }
        }
    }
    
    private func verifyCode() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                _ = try await authService.verifyCode(code, for: phoneNumber)
            } catch {
                errorMessage = error.localizedDescription
                code = ""
            }
            isLoading = false
        }
    }
    
    private func resendCode() {
        countdown = 60
        canResend = false
        Task {
            try? await authService.sendSMSCode(to: phoneNumber)
        }
    }
}
