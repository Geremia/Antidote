//
//  ProfileSettings.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 16/09/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

private struct Constants {
    static let UnlockPinCodeKey = "UnlockPinCodeKey"
    static let UseTouchIDKey = "UseTouchIDKey"
    static let LockTimeoutKey = "LockTimeoutKey"
}

class ProfileSettings: NSObject, NSCoding {
    enum LockTimeout: String {
        case Immediately
        case Seconds30
        case Minute1
        case Minute2
        case Minute5
    }

    var unlockPinCode: String?
    var useTouchID: Bool
    var lockTimeout: LockTimeout

    required override init() {
        unlockPinCode = nil
        useTouchID = false
        lockTimeout = .Immediately

        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        unlockPinCode = aDecoder.decodeObject(forKey: Constants.UnlockPinCodeKey) as? String
        useTouchID = aDecoder.decodeBool(forKey: Constants.UseTouchIDKey)

        if let rawTimeout = aDecoder.decodeObject(forKey: Constants.LockTimeoutKey) as? String {
            lockTimeout = LockTimeout(rawValue: rawTimeout) ?? .Immediately
        }
        else {
            lockTimeout = .Immediately
        }

        super.init()
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(unlockPinCode, forKey: Constants.UnlockPinCodeKey)
        aCoder.encode(useTouchID, forKey: Constants.UseTouchIDKey)
        aCoder.encode(lockTimeout.rawValue, forKey: Constants.LockTimeoutKey)
    }
}
