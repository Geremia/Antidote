//
//  NotificationWindow.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 25/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let AnimationDuration = 0.3
    static let ConnectingBlinkPeriod = 1.0
}

class NotificationWindow: UIWindow {
    fileprivate let theme: Theme

    fileprivate var connectingView: UIView!
    fileprivate var connectingViewTopConstraint: Constraint!

    init(theme: Theme) {
        self.theme = theme

        super.init(frame: UIScreen.main.bounds)

        windowLevel = UIWindowLevelStatusBar + 1
        makeKeyAndVisible()
        backgroundColor = .clear

        createRootViewController()
        createConnectingView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            let converted = convert(point, to: subview)

            if subview.hitTest(converted, with: event) != nil {
                return true
            }
        }

        return false
    }

    func showConnectingView(_ show: Bool, animated: Bool) {
        let showPreparation = {
            self.connectingView.isHidden = false
        }

        let showBlock = {
            self.connectingViewTopConstraint.update(offset: 0.0)
            self.layoutIfNeeded()
        }

        let showCompletion = {}

        let hidePreparation = {}

        let hideBlock = {
            self.connectingViewTopConstraint.update(offset: -self.connectingView.frame.size.height)
            self.layoutIfNeeded()
        }

        let hideCompletion = {
            self.connectingView.isHidden = true
        }

        show ? showPreparation() : hidePreparation()

        if animated {
            UIView.animate(withDuration: Constants.AnimationDuration, animations: {
                show ? showBlock() : hideBlock()
            }, completion: { finished in
                show ? showCompletion() : hideCompletion()
            })
        }
        else {
            show ? showBlock() : hideBlock()
            show ? showCompletion() : hideCompletion()
        }
    }
}

private extension NotificationWindow {
    func createRootViewController() {
        rootViewController = UIViewController()
        rootViewController!.view = ViewPassingGestures()
        rootViewController!.view.backgroundColor = .clear
    }

    func createConnectingView() {
        connectingView = UIView()
        connectingView!.backgroundColor = theme.colorForType(.ConnectingBackground)
        addSubview(connectingView!)

        let label = UILabel()
        label.textColor = theme.colorForType(.ConnectingText)
        label.backgroundColor = .clear
        label.text = String(localized: "connecting_label")
        label.textAlignment = .center
        label.font = UIFont.antidoteFontWithSize(12.0, weight: .light)
        connectingView!.addSubview(label)

        label.alpha = 0.0
        UIView.animate(withDuration: Constants.ConnectingBlinkPeriod, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            label.alpha = 1.0
        }, completion: nil)

        connectingView!.snp.makeConstraints {
            connectingViewTopConstraint = $0.top.equalTo(self).constraint
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(UIApplication.shared.statusBarFrame.size.height)
        }

        label.snp.makeConstraints {
            $0.edges.equalTo(connectingView!)
        }
    }
}
