//
//  UserStatus.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 20/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

enum UserStatus {
    case offline
    case online
    case away
    case busy

    init(connectionStatus: OCTToxConnectionStatus, userStatus: OCTToxUserStatus) {
        switch (connectionStatus, userStatus) {
            case (.none, _):
                self = .offline
            case (_, .none):
                self = .online
            case (_, .away):
                self = .away
            case (_, .busy):
                self = .busy
        }
    }

    func toString() -> String {
        switch self {
            case .offline:
                return String(localized: "status_offline")
            case .online:
                return String(localized: "status_online")
            case .away:
                return String(localized: "status_away")
            case .busy:
                return String(localized: "status_busy")
        }
    }
}
