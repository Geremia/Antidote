//
//  KeyboardNotificationController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 25/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

class KeyboardNotificationController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(KeyboardNotificationController.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(KeyboardNotificationController.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }

    func keyboardWillShowAnimated(keyboardFrame frame: CGRect) {
        // nop
    }

    func keyboardWillHideAnimated(keyboardFrame frame: CGRect) {
        // nop
    }

    func keyboardWillShowNotification(_ notification: Notification) {
        handleNotification(notification, willShow: true)
    }

    func keyboardWillHideNotification(_ notification: Notification) {
        handleNotification(notification, willShow: false)
    }
}

private extension KeyboardNotificationController {
    func handleNotification(_ notification: Notification, willShow: Bool) {
        let userInfo = (notification as NSNotification).userInfo!

        let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!

        let options: UIViewAnimationOptions

        switch curve {
            case .easeInOut:
                options = UIViewAnimationOptions()
            case .easeIn:
                options = .curveEaseIn
            case .easeOut:
                options = .curveEaseOut
            case .linear:
                options = .curveLinear
        }

        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { [unowned self] in
            willShow ? self.keyboardWillShowAnimated(keyboardFrame: frame) : self.keyboardWillHideAnimated(keyboardFrame: frame)
        }, completion: nil)
    }
}
