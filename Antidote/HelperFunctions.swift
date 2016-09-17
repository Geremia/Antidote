//
//  HelperFunctions.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 25/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

func isAddressString(_ string: String) -> Bool {
    let nsstring = string as NSString

    if nsstring.length != Int(kOCTToxAddressLength) {
        return false
    }

    let validChars = CharacterSet(charactersIn: "1234567890abcdefABCDEF")
    let components = nsstring.components(separatedBy: validChars)
    let leftChars = components.joined(separator: "")

    return leftChars.isEmpty
}
