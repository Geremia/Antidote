//
//  UIApplicationExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 14.02.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit

extension UIApplication {
    class var isActive: Bool {
        get {
            switch shared.applicationState {
                case .active:
                    return true
                case .inactive:
                    return false
                case .background:
                    return false
            }
        }
    }
}
