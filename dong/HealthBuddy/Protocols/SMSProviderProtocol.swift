import Foundation

protocol SMSProviderProtocol {
    func sendVerificationCode(to phoneNumber: String) async throws -> String
    func verifyCode(_ code: String, requestId: String) async throws -> Bool
}
