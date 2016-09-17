//
//  SettingsMainController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22/01/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation
import MessageUI

protocol SettingsMainControllerDelegate: class {
    func settingsMainControllerShowAboutScreen(_ controller: SettingsMainController)
    func settingsMainControllerShowAdvancedSettings(_ controller: SettingsMainController)
    func settingsMainControllerChangeAutodownloadImages(_ controller: SettingsMainController)
}

class SettingsMainController: StaticTableController {
    weak var delegate: SettingsMainControllerDelegate?

    fileprivate let theme: Theme
    fileprivate let userDefaults = UserDefaultsManager()

    fileprivate let aboutModel = StaticTableDefaultCellModel()
    fileprivate let autodownloadImagesModel = StaticTableInfoCellModel()
    fileprivate let notificationsModel = StaticTableSwitchCellModel()
    fileprivate let advancedSettingsModel = StaticTableDefaultCellModel()
    fileprivate let feedbackModel = StaticTableButtonCellModel()

    init(theme: Theme) {
        self.theme = theme

        super.init(theme: theme, style: .grouped, model: [
            [
                aboutModel,
            ],
            [
                autodownloadImagesModel,
            ],
            [
                notificationsModel,
            ],
            [
                advancedSettingsModel,
            ],
            [
                feedbackModel,
            ],
        ], footers: [
            nil,
            String(localized: "settings_autodownload_images_description"),
            String(localized: "settings_notifications_description"),
            nil,
            nil,
        ])

        title = String(localized: "settings_title")
        updateModels()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateModels()
        reloadTableView()
    }
}

extension SettingsMainController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

private extension SettingsMainController{
    func updateModels() {
        aboutModel.value = String(localized: "settings_about")
        aboutModel.didSelectHandler = showAboutScreen
        aboutModel.rightImageType = .arrow

        autodownloadImagesModel.title = String(localized: "settings_autodownload_images")
        autodownloadImagesModel.showArrow = true
        autodownloadImagesModel.didSelectHandler = changeAutodownloadImages
        switch userDefaults.autodownloadImages {
            case .Never:
                autodownloadImagesModel.value = String(localized: "settings_never")
            case .UsingWiFi:
                autodownloadImagesModel.value = String(localized: "settings_wifi")
            case .Always:
                autodownloadImagesModel.value = String(localized: "settings_always")
        }

        notificationsModel.title = String(localized: "settings_notifications_message_preview")
        notificationsModel.on = userDefaults.showNotificationPreview
        notificationsModel.valueChangedHandler = notificationsValueChanged

        advancedSettingsModel.value = String(localized: "settings_advanced_settings")
        advancedSettingsModel.didSelectHandler = showAdvancedSettings
        advancedSettingsModel.rightImageType = .arrow

        feedbackModel.title = String(localized: "settings_feedback")
        feedbackModel.didSelectHandler = feedback
    }

    func showAboutScreen(_: StaticTableBaseCell) {
        delegate?.settingsMainControllerShowAboutScreen(self)
    }

    func notificationsValueChanged(_ on: Bool) {
        userDefaults.showNotificationPreview = on
    }

    func changeAutodownloadImages(_: StaticTableBaseCell) {
        delegate?.settingsMainControllerChangeAutodownloadImages(self)
    }

    func showAdvancedSettings(_: StaticTableBaseCell) {
        delegate?.settingsMainControllerShowAdvancedSettings(self)
    }

    func feedback(_: StaticTableBaseCell) {
        guard MFMailComposeViewController.canSendMail() else {
            UIAlertController.showErrorWithMessage(String(localized: "settings_configure_email"), retryBlock: nil)
            return
        }

        let controller = MFMailComposeViewController()
        controller.navigationBar.tintColor = theme.colorForType(.LinkText)
        controller.setSubject("Feedback")
        controller.setToRecipients(["feedback@antidote.im"])
        controller.mailComposeDelegate = self

        present(controller, animated: true, completion: nil)
    }
}
