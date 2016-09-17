//
//  StaticTableSwitchCell.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22.01.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit
import SnapKit

class StaticTableSwitchCell: StaticTableBaseCell {
    fileprivate var valueChangedHandler: ((Bool) -> Void)?

    fileprivate var titleLabel: UILabel!
    fileprivate var switchView: UISwitch!

    override func setupWithTheme(_ theme: Theme, model: BaseCellModel) {
        super.setupWithTheme(theme, model: model)

        guard let switchModel = model as? StaticTableSwitchCellModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        selectionStyle = .none

        titleLabel.textColor = theme.colorForType(.NormalText)
        titleLabel.text = switchModel.title

        switchView.isEnabled = switchModel.enabled
        switchView.tintColor = theme.colorForType(.LinkText)
        switchView.isOn = switchModel.on

        valueChangedHandler = switchModel.valueChangedHandler
    }

    override func createViews() {
        super.createViews()

        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        customContentView.addSubview(titleLabel)

        switchView = UISwitch()
        switchView.addTarget(self, action: #selector(StaticTableSwitchCell.switchValueChanged), for: .valueChanged)
        customContentView.addSubview(switchView)
    }

    override func installConstraints() {
        super.installConstraints()

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(customContentView)
            $0.leading.equalTo(customContentView)
        }

        switchView.snp.makeConstraints {
            $0.centerY.equalTo(customContentView)
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(customContentView)
        }
    }
}

extension StaticTableSwitchCell {
    func switchValueChanged() {
        valueChangedHandler?(switchView.isOn)
    }
}
