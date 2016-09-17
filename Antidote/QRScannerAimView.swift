//
//  QRScannerAimView.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 26/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

class QRScannerAimView: UIView {
    fileprivate let dashLayer: CAShapeLayer

    init(theme: Theme) {
        dashLayer = CAShapeLayer()

        super.init(frame: CGRect.zero)

        configureDashLayer(theme)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var frame: CGRect {
        didSet {
            dashLayer.path = UIBezierPath(rect: bounds).cgPath
            dashLayer.frame = bounds
        }
    }
}

private extension QRScannerAimView {
    func configureDashLayer(_ theme: Theme) {
        dashLayer.strokeColor = theme.colorForType(.LinkText).cgColor
        dashLayer.fillColor = UIColor.clear.cgColor
        dashLayer.lineDashPattern = [20, 5]
        dashLayer.lineWidth = 2.0
        layer.addSublayer(dashLayer)
    }
}
