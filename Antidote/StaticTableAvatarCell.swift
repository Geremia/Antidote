//
//  StaticTableAvatarCell.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 03/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let AvatarVerticalOffset = 10.0
}

class StaticTableAvatarCell: StaticTableBaseCell {
    fileprivate var didTapOnAvatar: ((StaticTableAvatarCell) -> Void)?

    fileprivate var button: UIButton!

    override func setupWithTheme(_ theme: Theme, model: BaseCellModel) {
        super.setupWithTheme(theme, model: model)

        guard let avatarModel = model as? StaticTableAvatarCellModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        selectionStyle = .none

        button.isUserInteractionEnabled = avatarModel.userInteractionEnabled
        button.setImage(avatarModel.avatar, for: UIControlState())
        didTapOnAvatar = avatarModel.didTapOnAvatar
    }

    override func createViews() {
        super.createViews()

        button = UIButton()
        button.layer.cornerRadius = StaticTableAvatarCellModel.Constants.AvatarImageSize / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(StaticTableAvatarCell.buttonPressed), for: .touchUpInside)
        customContentView.addSubview(button)
    }

    override func installConstraints() {
        super.installConstraints()

        button.snp.makeConstraints {
            $0.centerX.equalTo(customContentView)
            $0.top.equalTo(customContentView).offset(Constants.AvatarVerticalOffset)
            $0.bottom.equalTo(customContentView).offset(-Constants.AvatarVerticalOffset)
            $0.size.equalTo(StaticTableAvatarCellModel.Constants.AvatarImageSize)
        }
    }
}

extension StaticTableAvatarCell {
    func buttonPressed() {
        didTapOnAvatar?(self)
    }
}
