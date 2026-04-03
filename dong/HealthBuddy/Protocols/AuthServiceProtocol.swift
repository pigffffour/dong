import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

protocol AuthServiceProtocol: AnyObject {
    var isLoggedIn: Bool { get }
    var currentUser: User? { get }
    func sendSMSCode(to phoneNumber: String) async throws
    func verifyCode(_ code: String, for phoneNumber: String) async throws -> User
    func logout()
}
