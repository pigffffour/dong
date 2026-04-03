import Foundation
import Combine

enum AuthError: LocalizedError {
    case invalidPhoneNumber
    case noCodeRequested
    case invalidCode
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber: return "请输入正确的手机号"
        case .noCodeRequested: return "请先获取验证码"
        case .invalidCode: return "验证码错误"
        case .networkError(let e): return "网络错误：\(e.localizedDescription)"
        }
    }
}

@MainActor
final class AuthService: ObservableObject, AuthServiceProtocol {
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var currentUser: User?
    
    private let smsProvider: SMSProviderProtocol
    private let keychain: KeychainService
    private let persistence: PersistenceServiceProtocol
    private var currentRequestId: String?
    private var pendingPhoneNumber: String?
    
    init(smsProvider: SMSProviderProtocol, keychain: KeychainService, persistence: PersistenceServiceProtocol) {
        self.smsProvider = smsProvider
        self.keychain = keychain
        self.persistence = persistence
        restoreSession()
    }
    
    private func restoreSession() {
        if let token = keychain.loadAuthToken(), token.expiresAt > Date() {
            if let user = try? persistence.loadUser() {
                self.currentUser = user
                self.isLoggedIn = true
            }
        }
    }
    
    func sendSMSCode(to phoneNumber: String) async throws {
        let cleaned = phoneNumber.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 11, cleaned.allSatisfy(\.isNumber) else {
            throw AuthError.invalidPhoneNumber
        }
        let normalized = "+86\(cleaned)"
        pendingPhoneNumber = normalized
        currentRequestId = try await smsProvider.sendVerificationCode(to: normalized)
    }
    
    func verifyCode(_ code: String, for phoneNumber: String) async throws -> User {
        guard let requestId = currentRequestId else {
            throw AuthError.noCodeRequested
        }
        let verified = try await smsProvider.verifyCode(code, requestId: requestId)
        guard verified else {
            throw AuthError.invalidCode
        }
        
        // 创建或恢复用户
        let user: User
        if let existingUser = try? persistence.loadUser() {
            user = existingUser
        } else {
            let cleaned = phoneNumber.replacingOccurrences(of: " ", with: "")
            user = User(phoneNumber: "+86\(cleaned)")
            try? persistence.saveUser(user)
        }
        
        // 保存 token（Mock 模式下创建本地 token）
        let token = AuthToken(
            accessToken: UUID().uuidString,
            refreshToken: UUID().uuidString,
            expiresAt: Date().addingTimeInterval(30 * 24 * 3600)
        )
        keychain.saveAuthToken(token)
        
        self.currentUser = user
        self.isLoggedIn = true
        return user
    }
    
    func updateUser(_ user: User) {
        self.currentUser = user
        try? persistence.saveUser(user)
    }
    
    func logout() {
        keychain.deleteAuthToken()
        isLoggedIn = false
        currentUser = nil
        currentRequestId = nil
        pendingPhoneNumber = nil
    }
}
