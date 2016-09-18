//
//  InterfaceIdiom.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 19.01.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

enum InterfaceIdiom {
    case iPhone
    case iPad

    static func current() -> InterfaceIdiom {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return .iPad
        }
        else {
            // assume that we are on iPhone
            return .iPhone
        }
    }
}

