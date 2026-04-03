import Foundation

/// 阿里云短信服务提供者（通过自建后端中转，避免客户端暴露密钥）
final class AliyunSMSProvider: SMSProviderProtocol {
    private let backendURL: String
    
    init(backendURL: String) {
        self.backendURL = backendURL
    }
    
    func sendVerificationCode(to phoneNumber: String) async throws -> String {
        var request = URLRequest(url: URL(string: "\(backendURL)/sms/send")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["phoneNumber": phoneNumber])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw SMSError.sendFailed
        }
        let result = try JSONDecoder().decode(SendResponse.self, from: data)
        return result.requestId
    }
    
    func verifyCode(_ code: String, requestId: String) async throws -> Bool {
        var request = URLRequest(url: URL(string: "\(backendURL)/sms/verify")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["code": code, "requestId": requestId])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw SMSError.verifyFailed
        }
        let result = try JSONDecoder().decode(VerifyResponse.self, from: data)
        return result.verified
    }
    
    enum SMSError: LocalizedError {
        case sendFailed
        case verifyFailed
        
        var errorDescription: String? {
            switch self {
            case .sendFailed: return "短信发送失败"
            case .verifyFailed: return "验证码校验失败"
            }
        }
    }
    
    private struct SendResponse: Codable { let requestId: String }
    private struct VerifyResponse: Codable { let verified: Bool }
}
