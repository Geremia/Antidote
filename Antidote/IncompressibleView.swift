//
//  IncompressibleView.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 19.01.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

class IncompressibleView: UIView {
    var customIntrinsicContentSize: CGSize = CGSize.zero

    override var intrinsicContentSize : CGSize {
        return customIntrinsicContentSize
    }
}
