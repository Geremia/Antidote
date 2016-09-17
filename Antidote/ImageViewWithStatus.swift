//
//  ImageViewWithStatus.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 20/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let Sqrt2: CGFloat = 1.4142135623731
}

class ImageViewWithStatus: UIView {
    var imageView: UIImageView!
    var userStatusView: UserStatusView!

    fileprivate var userStatusViewCenterConstrant: Constraint!

    init() {
        super.init(frame: CGRect.zero)

        createViews()
        installConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.cornerRadius = frame.size.width / 2

        let offset = bounds.size.width / (2 * Constants.Sqrt2)
        userStatusViewCenterConstrant.update(offset: offset)
    }
}

private extension ImageViewWithStatus {
    func createViews() {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.layer.masksToBounds = true
        // imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)

        userStatusView = UserStatusView()
        addSubview(userStatusView)
    }

    func installConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }

        userStatusView.snp.makeConstraints {
            userStatusViewCenterConstrant = $0.center.equalTo(self).constraint
            $0.size.equalTo(UserStatusView.Constants.DefaultSize)
        }
    }
}
