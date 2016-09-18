//
//  ChangeAutodownloadImagesController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 25.03.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import UIKit

protocol ChangeAutodownloadImagesControllerDelegate: class {
    func changeAutodownloadImagesControllerDidChange(_ controller: ChangeAutodownloadImagesController)
}

class ChangeAutodownloadImagesController: StaticTableController {
    weak var delegate: ChangeAutodownloadImagesControllerDelegate?

    fileprivate let userDefaults: UserDefaultsManager
    fileprivate let selectedStatus: UserDefaultsManager.AutodownloadImages

    fileprivate let neverModel = StaticTableDefaultCellModel()
    fileprivate let wifiModel = StaticTableDefaultCellModel()
    fileprivate let alwaysModel = StaticTableDefaultCellModel()

    init(theme: Theme) {
        self.userDefaults = UserDefaultsManager()
        self.selectedStatus = userDefaults.autodownloadImages

        super.init(theme: theme, style: .plain, model: [
            [
                neverModel,
                wifiModel,
                alwaysModel,
            ],
        ])

        updateModels()

        title = String(localized: "settings_autodownload_images")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChangeAutodownloadImagesController {
    func updateModels() {
        neverModel.value = String(localized: "settings_never")
        neverModel.didSelectHandler = changeNever

        wifiModel.value = String(localized: "settings_using_wifi")
        wifiModel.didSelectHandler = changeUsingWifi

        alwaysModel.value = String(localized: "settings_always")
        alwaysModel.didSelectHandler = changeAlways

        switch selectedStatus {
            case .Never:
                neverModel.rightImageType = .checkmark
            case .UsingWiFi:
                wifiModel.rightImageType = .checkmark
            case .Always:
                alwaysModel.rightImageType = .checkmark
        }
    }

    func changeNever(_: StaticTableBaseCell) {
        userDefaults.autodownloadImages = .Never
        delegate?.changeAutodownloadImagesControllerDidChange(self)
    }

    func changeUsingWifi(_: StaticTableBaseCell) {
        userDefaults.autodownloadImages = .UsingWiFi
        delegate?.changeAutodownloadImagesControllerDidChange(self)
    }

    func changeAlways(_: StaticTableBaseCell) {
        userDefaults.autodownloadImages = .Always
        delegate?.changeAutodownloadImagesControllerDidChange(self)
    }
}
