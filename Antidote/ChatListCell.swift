//
//  ChatListCell.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 12/01/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit
import SnapKit

class ChatListCell: BaseCell {
    struct Constants {
        static let AvatarSize = 40.0
        static let AvatarLeftOffset = 10.0
        static let AvatarRightOffset = 16.0

        static let NicknameLabelHeight = 22.0
        static let MessageLabelHeight = 22.0

        static let NicknameToDateMinOffset = 5.0
        static let DateToArrowOffset = 5.0

        static let RightOffset = -7.0
        static let VerticalOffset = 3.0
    }

    fileprivate var avatarView: ImageViewWithStatus!
    fileprivate var nicknameLabel: UILabel!
    fileprivate var messageLabel: UILabel!
    fileprivate var dateLabel: UILabel!
    fileprivate var arrowImageView: UIImageView!

    override func setupWithTheme(_ theme: Theme, model: BaseCellModel) {
        super.setupWithTheme(theme, model: model)

        guard let chatModel = model as? ChatListCellModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        separatorInset.left = CGFloat(Constants.AvatarLeftOffset + Constants.AvatarSize + Constants.AvatarRightOffset)

        avatarView.imageView.image = chatModel.avatar
        avatarView.userStatusView.theme = theme
        avatarView.userStatusView.userStatus = chatModel.status

        nicknameLabel.text = chatModel.nickname
        nicknameLabel.textColor = theme.colorForType(.NormalText)

        messageLabel.text = chatModel.message
        messageLabel.textColor = theme.colorForType(.ChatListCellMessage)

        dateLabel.text = chatModel.dateText
        dateLabel.textColor = theme.colorForType(.ChatListCellMessage)

        backgroundColor = chatModel.isUnread ? theme.colorForType(.ChatListCellUnreadBackground) : .clear
    }

    override func createViews() {
        super.createViews()

        avatarView = ImageViewWithStatus()
        contentView.addSubview(avatarView)

        nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.systemFont(ofSize: 18.0)
        contentView.addSubview(nicknameLabel)

        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 12.0)
        contentView.addSubview(messageLabel)

        dateLabel = UILabel()
        dateLabel.font = UIFont.antidoteFontWithSize(12.0, weight: .light)
        contentView.addSubview(dateLabel)

        let image = UIImage(named: "right-arrow")!.flippedToCorrectLayout()

        arrowImageView = UIImageView(image: image)
        arrowImageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        contentView.addSubview(arrowImageView)
    }

    override func installConstraints() {
        super.installConstraints()

        avatarView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(Constants.AvatarLeftOffset)
            $0.centerY.equalTo(contentView)
            $0.size.equalTo(Constants.AvatarSize)
        }

        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(Constants.AvatarRightOffset)
            $0.top.equalTo(contentView).offset(Constants.VerticalOffset)
            $0.height.equalTo(Constants.NicknameLabelHeight)
        }

        messageLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalTo(contentView).offset(Constants.RightOffset)
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.bottom.equalTo(contentView).offset(-Constants.VerticalOffset)
            $0.height.equalTo(Constants.MessageLabelHeight)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(nicknameLabel.snp.trailing).offset(Constants.NicknameToDateMinOffset)
            $0.top.equalTo(nicknameLabel)
            $0.height.equalTo(nicknameLabel)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.greaterThanOrEqualTo(dateLabel.snp.trailing).offset(Constants.DateToArrowOffset)
            $0.trailing.equalTo(contentView).offset(Constants.RightOffset)
        }
    }
}
