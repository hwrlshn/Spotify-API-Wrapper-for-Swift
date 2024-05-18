//
//  KeychainService.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

internal final class KeychainService {
    
    internal static let shared: KeychainService = .init()
    
    func save(value: Any, forKey key: String) {
        // Check if the value already exists
        if isValueExists(key) {
            print("Key '\(key)' is already in use.")
            delete(forKey: key)
            print("Value for key '\(key)' has been removed and will be replaced with the new one.")
        }
        
        // Convert the value to Data
        let data: Data
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
        } catch {
            print("Failed to encode value to data: \(error)")
            return
        }
        
        // Prepare the query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Save the value to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            guard let errorMessage = SecCopyErrorMessageString(status, nil)
            else {
                print("Keychain saving error: \(status)")
                return
            }
            print("Keychain saving error: \(errorMessage)")
        }
    }
    
    func load(forKey key: String) -> Any? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess
        else {
            print("Keychain loading error: \(status)")
            return nil
        }
        if let retrievedData = dataTypeRef as? Data {
            // Attempt to decode the retrieved data
            do {
                let value = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(retrievedData)
                return value
            } catch {
                print("Failed to decode retrieved data: \(error)")
                return nil
            }
        }
        return nil
    }
    
}

private extension KeychainService {
    
    func isValueExists(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            if let errorMessage = SecCopyErrorMessageString(status, nil) {
                print("Keychain deletion error: \(errorMessage)")
            } else {
                print("Keychain deletion error: \(status)")
            }
        }
    }
    
}
