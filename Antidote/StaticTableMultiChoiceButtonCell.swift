//
//  StaticTableMultiChoiceButtonCell.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22.02.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let HorizontalOffset = 8.0
    static let Height = 40.0
}

class StaticTableMultiChoiceButtonCell: StaticTableBaseCell {
    fileprivate var buttonsContainer: UIView!

    override func setupWithTheme(_ theme: Theme, model: BaseCellModel) {
        super.setupWithTheme(theme, model: model)

        guard let multiModel = model as? StaticTableMultiChoiceButtonCellModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        selectionStyle = .none

        _ = buttonsContainer.subviews.map {
            $0.removeFromSuperview()
        }

        var previousButton: RoundedButton?

        for buttonModel in multiModel.buttons {
            let button = addButtonWithTheme(theme, model: buttonModel)

            button.snp.makeConstraints {
                $0.top.bottom.equalTo(buttonsContainer)

                if let previousButton = previousButton {
                    $0.leading.equalTo(previousButton.snp.trailing).offset(Constants.HorizontalOffset)
                    $0.width.equalTo(previousButton)
                }
                else {
                    $0.leading.equalTo(buttonsContainer)
                }
            }
            previousButton = button
        }

        if let previousButton = previousButton {
            previousButton.snp.makeConstraints {
                $0.trailing.equalTo(buttonsContainer)
            }
        }
    }

    override func createViews() {
        super.createViews()

        buttonsContainer = UIView()
        buttonsContainer.backgroundColor = .clear
        customContentView.addSubview(buttonsContainer)
    }

    override func installConstraints() {
        super.installConstraints()

        buttonsContainer.snp.makeConstraints {
            $0.leading.trailing.equalTo(customContentView)
            $0.centerY.equalTo(customContentView)
            $0.height.equalTo(Constants.Height)
        }
    }

    func addButtonWithTheme(_ theme: Theme, model: StaticTableMultiChoiceButtonCellModel.ButtonModel) -> RoundedButton {
        let type: RoundedButton.ButtonType

        switch model.style {
            case .negative:
                type = .runningNegative
            case .positive:
                type = .runningPositive
        }

        let button = RoundedButton(theme: theme, type: type)
        button.setTitle(model.title, for: UIControlState())
        button.addTarget(model.target, action: model.action, for: .touchUpInside)
        buttonsContainer.addSubview(button)

        return button
    }
}
