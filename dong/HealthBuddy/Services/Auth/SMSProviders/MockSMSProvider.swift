import Foundation

/// 开发环境用的 Mock SMS 提供者，固定验证码 123456
final class MockSMSProvider: SMSProviderProtocol {
    private let validCode = "123456"
    
    func sendVerificationCode(to phoneNumber: String) async throws -> String {
        try await Task.sleep(nanoseconds: 500_000_000)
        print("[MockSMS] 验证码已发送至 \(phoneNumber): \(validCode)")
        return "mock-request-\(UUID().uuidString)"
    }
    
    func verifyCode(_ code: String, requestId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 300_000_000)
        return code == validCode
    }
}
