//
//  UIFontExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 04.04.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit

extension UIFont {
    enum Weight {
        case light
        case bold

        func float() -> CGFloat {
            if #available(iOS 8.2, *) {
                switch self {
                    case .light:
                        return UIFontWeightLight
                    case .bold:
                        return UIFontWeightBold
                }
            }

            return 0.0
        }

        func name() -> String {
            switch self {
                case .light:
                    return "HelveticaNeue-Light"
                case .bold:
                    return "HelveticaNeue-Bold"
            }
        }
    }

    class func antidoteFontWithSize(_ size: CGFloat, weight: Weight) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: weight.float())
        } else {
            return UIFont(name: weight.name(), size: size)!
        }
    }
}
