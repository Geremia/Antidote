//
//  SettingsAboutController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22/01/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

class SettingsAboutController: StaticTableController {
    fileprivate let antidoteVersionModel = StaticTableInfoCellModel()
    fileprivate let antidoteBuildModel = StaticTableInfoCellModel()
    fileprivate let toxcoreVersionModel = StaticTableInfoCellModel()

    init(theme: Theme) {
        super.init(theme: theme, style: .grouped, model: [
            [
                antidoteVersionModel,
                antidoteBuildModel,
            ],
            [
                toxcoreVersionModel,
            ],
        ])

        title = String(localized: "settings_about")
        updateModels()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsAboutController {
    func updateModels() {
        antidoteVersionModel.title = String(localized: "settings_antidote_version")
        antidoteVersionModel.value =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        antidoteBuildModel.title = String(localized: "settings_antidote_build")
        antidoteBuildModel.value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        toxcoreVersionModel.title = String(localized: "settings_toxcore_version")
        toxcoreVersionModel.value = OCTTox.version()
    }
}
