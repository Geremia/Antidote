//
//  ProgressCircleView.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22.03.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit

private struct Constants {
    static let LineWidth: CGFloat = 6.0
    static let AnimationDuration = 1.0
}

class ProgressCircleView: UIView {
    fileprivate let backgroundLayer: CAShapeLayer
    fileprivate let progressLayer: CAShapeLayer

    var backgroundLineColor: UIColor? {
        didSet {
            backgroundLayer.strokeColor = backgroundLineColor?.cgColor
        }
    }

    var lineColor: UIColor? {
        didSet {
            progressLayer.strokeColor = lineColor?.cgColor
        }
    }

    /// From 0.0 to 1.0
    var progress: CGFloat = 0.0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }

    override init(frame: CGRect) {
        backgroundLayer = CAShapeLayer()
        progressLayer = CAShapeLayer()

        super.init(frame: frame)

        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = Constants.LineWidth
        layer.addSublayer(backgroundLayer)

        progressLayer.strokeEnd = progress
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = Constants.LineWidth
        layer.addSublayer(progressLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let bezierPath = UIBezierPath()
        bezierPath.addArc(
                withCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2),
                radius: bounds.size.width / 2,
                startAngle: CGFloat(-M_PI_2),
                endAngle: CGFloat(M_PI + M_PI_2),
                clockwise: true)

        backgroundLayer.path = bezierPath.cgPath
        backgroundLayer.frame = bounds
        progressLayer.path = bezierPath.cgPath
        progressLayer.frame = bounds
    }
}
