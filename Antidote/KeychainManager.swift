//
//  KeychainManager.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 13/08/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

private struct Constants {
    static let ActiveAccountDataService = "me.dvor.Antidote.KeychainManager.ActiveAccountDataService"

    static let toxPasswordForActiveAccount = "toxPasswordForActiveAccount"
}

class KeychainManager {
    /// Tox password used to encrypt/decrypt active account.
    var toxPasswordForActiveAccount: String? {
        get {
            return getStringForKey(Constants.toxPasswordForActiveAccount)
        }
        set {
            setString(newValue, forKey: Constants.toxPasswordForActiveAccount)
        }
    }

    /// Removes all data related to active account.
    func deleteActiveAccountData() {
        self.toxPasswordForActiveAccount = nil
    }
}

private extension KeychainManager {
    func getStringForKey(_ key: String) -> String? {
        guard let data = getDataForKey(key) else {
            return nil
        }

        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
    }

    func setString(_ string: String?, forKey key: String) {
        let data = string?.data(using: String.Encoding.utf8)
        setData(data, forKey: key)
    }

    func getBoolForKey(_ key: String) -> Bool? {
        guard let data = getDataForKey(key) else {
            return nil
        }

        guard let firstBit = data.first else {
            return nil
        }

        return firstBit == 1
    }

    func setBool(_ value: Bool?, forKey key: String) {
        var bytes: [UInt8] = [0]

        if let value = value {
            if value {
                bytes = [1]
            }
        }

        let data = Data(bytes: bytes)

        setData(data, forKey: key)
    }

    func getDataForKey(_ key: String) -> Data? {
        var query = genericQueryWithKey(key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        if status == errSecItemNotFound {
            return nil
        }

        guard status == noErr else {
            log("Error when getting keychain data for key \(key), status \(status)")
            return nil
        }

        guard let data = queryResult as? Data else {
            log("Unexpected data for key \(key)")
            return nil
        }

        return data
    }

    func setData(_ newData: Data?, forKey key: String) {
        let oldData = getDataForKey(key)

        switch (oldData, newData) {
            case (.some(_), .some(let data)):
                // Update
                let query = genericQueryWithKey(key)

                var attributesToUpdate = [String : AnyObject]()
                attributesToUpdate[kSecValueData as String] = data as AnyObject?

                let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
                guard status == noErr else {
                    log("Error when updating keychain data for key \(key), status \(status)")
                    return
                }

            case (.some(_), .none):
                // Delete
                let query = genericQueryWithKey(key)
                let status = SecItemDelete(query as CFDictionary)
                guard status == noErr else {
                    log("Error when updating keychain data for key \(key), status \(status)")
                    return
                }

            case (.none, .some(let data)):
                // Add
                var query = genericQueryWithKey(key)
                query[kSecValueData as String] = data as AnyObject?

                let status = SecItemAdd(query as CFDictionary, nil)
                guard status == noErr else {
                    log("Error when setting keychain data for key \(key), status \(status)")
                    return
                }

            case (.none, .none):
                // Nothing to do here, no changes
                break
        }
    }

    func genericQueryWithKey(_ key: String) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = Constants.ActiveAccountDataService as AnyObject?
        query[kSecAttrAccount as String] = key as AnyObject?
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        return query
    }
}
