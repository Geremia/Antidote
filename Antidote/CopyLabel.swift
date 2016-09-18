//
//  CopyLabel.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 14.02.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit

class CopyLabel: UILabel {
    var copyable = true {
        didSet {
            recognizer.isEnabled = copyable
        }
    }

    fileprivate var recognizer: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true

        recognizer = UITapGestureRecognizer(target: self, action: #selector(CopyLabel.tapGesture))
        addGestureRecognizer(recognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Actions
extension CopyLabel {
    func tapGesture() {
        // This fixes issue with calling UIMenuController after UIActionSheet was presented.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.makeKey()

        becomeFirstResponder()

        let menu = UIMenuController.shared
        menu.setTargetRect(frame, in: superview!)
        menu.setMenuVisible(true, animated: true)
    }
}

// MARK: Copying
extension CopyLabel {
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }
}
