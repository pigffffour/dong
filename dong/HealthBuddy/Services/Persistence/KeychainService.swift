import Foundation
import Security

final class KeychainService {
    private let serviceName = "com.healthbuddy"
    
    // MARK: - Auth Token
    
    func saveAuthToken(_ token: AuthToken) {
        save(key: "authToken", data: try? JSONEncoder().encode(token))
    }
    
    func loadAuthToken() -> AuthToken? {
        guard let data = load(key: "authToken") else { return nil }
        return try? JSONDecoder().decode(AuthToken.self, from: data)
    }
    
    func deleteAuthToken() {
        delete(key: "authToken")
    }
    
    // MARK: - Generic Keychain Operations
    
    private func save(key: String, data: Data?) {
        guard let data = data else { return }
        delete(key: key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
