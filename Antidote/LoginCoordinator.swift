//
//  LoginCoordinator.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 07/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

protocol LoginCoordinatorDelegate: class {
    func loginCoordinatorDidLogin(_ coordinator: LoginCoordinator, manager: OCTManager, password: String)
}

private enum UserInfoKey: String {
    case ImportURL
    case LoginProfile
    case LoginConfigurationClosure
    case LoginErrorClosure
}

class LoginCoordinator {
    weak var delegate: LoginCoordinatorDelegate?

    fileprivate let window: UIWindow
    fileprivate let theme: Theme
    fileprivate let navigationController: UINavigationController

    fileprivate var createAccountCoordinator: LoginCreateAccountCoordinator?

    init(theme: Theme, window: UIWindow) {
        self.window = window
        self.theme = theme

        switch InterfaceIdiom.current() {
            case .iPhone:
                self.navigationController = PortraitNavigationController()
            case .iPad:
                self.navigationController = UINavigationController()
        }

        navigationController.navigationBar.tintColor = theme.colorForType(.LoginButtonText)
        navigationController.navigationBar.barTintColor = theme.loginNavigationBarColor
        navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: theme.colorForType(.LoginButtonText)
        ]
    }
}

// MARK: TopCoordinatorProtocol
extension LoginCoordinator: TopCoordinatorProtocol {
    func startWithOptions(_ options: CoordinatorOptions?) {
        let profileNames = ProfileManager().allProfileNames

        let controller: UIViewController = (profileNames.count > 0) ? createFormController() : createChoiceController()

        navigationController.pushViewController(controller, animated: false)
        window.rootViewController = navigationController
    }
    
    func handleLocalNotification(_ notification: UILocalNotification) {
        // nop
    }

    func handleInboxURL(_ url: URL) {
        guard url.isToxURL() else {
            return
        }

        let fileName = url.lastPathComponent

        let style: UIAlertControllerStyle

        switch InterfaceIdiom.current() {
            case .iPhone:
                style = .actionSheet
            case .iPad:
                style = .alert
        }

        let alert = UIAlertController(title: nil, message: fileName, preferredStyle: style)

        alert.addAction(UIAlertAction(title: String(localized: "create_profile"), style: .default) { [unowned self] _ -> Void in
            self.importToxProfileFromURL(url)
        })

        alert.addAction(UIAlertAction(title: String(localized: "alert_cancel"), style: .cancel, handler: nil))

        navigationController.present(alert, animated: true, completion: nil)
    }
}

extension LoginCoordinator: LoginFormControllerDelegate {
    func loginFormControllerLogin(_ controller: LoginFormController, profileName: String, password: String?) {
        loginWithProfile(profileName, password: password, errorClosure: { error in
            handleErrorWithType(.createOCTManager, error: error)
        })
    }

    func loginFormControllerCreateAccount(_ controller: LoginFormController) {
        showCreateAccountController()
    }

    func loginFormControllerImportProfile(_ controller: LoginFormController) {
        showImportProfileController()
    }

    func loginFormController(_ controller: LoginFormController, isProfileEncrypted profile: String) -> Bool {
        let path = ProfileManager().pathForProfileWithName(profile)

        let configuration = OCTManagerConfiguration.configurationWithBaseDirectory(path)!

        return OCTManager.isToxSaveEncrypted(atPath: configuration.fileStorage.pathForToxSaveFile)
    }
}

extension LoginCoordinator: LoginChoiceControllerDelegate {
    func loginChoiceControllerCreateAccount(_ controller: LoginChoiceController) {
        showCreateAccountController()
    }

    func loginChoiceControllerImportProfile(_ controller: LoginChoiceController) {
        showImportProfileController()
    }
}

extension LoginCoordinator: LoginCreateAccountCoordinatorDelegate {
    func loginCreateAccountCoordinator(_ coordinator: LoginCreateAccountCoordinator, 
                                       didCreateAccountWithProfileName profileName: String,
                                       username: String,
                                       password: String) {
        createProfileWithProfileName(profileName, username: username, copyFromURL: nil, password: password)
    }

    func loginCreateAccountCoordinator(_ coordinator: LoginCreateAccountCoordinator,
                                       didImportProfileWithProfileName profileName: String) {
        guard let url = coordinator.userInfo[UserInfoKey.ImportURL.rawValue] as? URL else {
            fatalError("URL should be non-nil when importing profile")
        }

        createProfileWithProfileName(profileName, username: nil, copyFromURL: url, password: nil)
    }

    func loginCreateAccountCoordinator(_ coordinator: LoginCreateAccountCoordinator, didCreatePassword password: String) {
        guard let profile = coordinator.userInfo[UserInfoKey.LoginProfile.rawValue] as? String else {
            fatalError("Profile should be non-nil on login")
        }

        let configurationClosure = coordinator.userInfo[UserInfoKey.LoginConfigurationClosure.rawValue] as? ((_ manager: OCTManager) -> Void)
        let errorClosure = coordinator.userInfo[UserInfoKey.LoginErrorClosure.rawValue] as? ((NSError) -> Void)

        loginWithProfile(profile, password: password, configurationClosure: configurationClosure, errorClosure: errorClosure)
    }
}

private extension LoginCoordinator {
    func createFormController() -> LoginFormController {
        let profileNames = ProfileManager().allProfileNames
        var selectedIndex = 0

        if let activeProfile = UserDefaultsManager().lastActiveProfile {
            selectedIndex = profileNames.index(of: activeProfile) ?? 0
        }

        let controller = LoginFormController(theme: theme, profileNames: profileNames, selectedIndex: selectedIndex)
        controller.delegate = self

        return controller
    }

    func createChoiceController() -> LoginChoiceController {
        let controller = LoginChoiceController(theme: theme)
        controller.delegate = self

        return controller
    }

    func showCreateAccountController() {
        let coordinator = LoginCreateAccountCoordinator(theme: theme,
                                                        navigationController: navigationController,
                                                        type: .createAccountAndPassword)
        coordinator.delegate = self
        coordinator.startWithOptions(nil)

        createAccountCoordinator = coordinator
    }

    func showImportProfileController() {
        let controller = TextViewController(
                resourceName: "import-profile",
                backgroundColor: theme.colorForType(.LoginBackground),
                titleColor: theme.colorForType(.LoginButtonText),
                textColor: theme.colorForType(.LoginDescriptionLabel))

        navigationController.pushViewController(controller, animated: true)
    }

    /**
     * @param profile The name of profile.
     * @param password Password to decrypt profile.
     * @param configurationClosure Closure called after login to configure profile.
     * @param errorClosure Closure called if any error occured during login.
     */
    func loginWithProfile(
            _ profile: String,
            password: String?,
            configurationClosure: ((_ manager: OCTManager) -> Void)? = nil,
            errorClosure: ((NSError) -> Void)? = nil)
    {
        guard let password = password else {
            let coordinator = LoginCreateAccountCoordinator(theme: theme,
                                                            navigationController: navigationController,
                                                            type: .createPassword)
            coordinator.delegate = self
            coordinator.userInfo[UserInfoKey.LoginProfile.rawValue] = profile
            coordinator.userInfo[UserInfoKey.LoginConfigurationClosure.rawValue] = configurationClosure
            coordinator.userInfo[UserInfoKey.LoginErrorClosure.rawValue] = errorClosure
            coordinator.startWithOptions(nil)

            createAccountCoordinator = coordinator
            return
        }

        let path = ProfileManager().pathForProfileWithName(profile)
        let configuration = OCTManagerConfiguration.configurationWithBaseDirectory(path)!

        let hud = JGProgressHUD(style: .dark)!
        hud.show(in: self.navigationController.view)

        OCTManager.manager(with: configuration, encryptPassword: password, successBlock: { [weak self] manager -> Void in
            hud.dismiss()

            configurationClosure?(manager)

            let userDefaults = UserDefaultsManager()
            userDefaults.lastActiveProfile = profile

            self?.delegate?.loginCoordinatorDidLogin(self!, manager: manager, password: password)

        }, failureBlock: { error -> Void in
            hud.dismiss()
            errorClosure?(error as NSError)
        })
    }

    func importToxProfileFromURL(_ url: URL) {
        let coordinator = LoginCreateAccountCoordinator(theme: theme,
                                                        navigationController: navigationController,
                                                        type: .importProfile)
        coordinator.userInfo[UserInfoKey.ImportURL.rawValue] = url
        coordinator.delegate = self
        coordinator.startWithOptions(nil)

        createAccountCoordinator = coordinator
    }

    func createProfileWithProfileName(_ profileName: String, username: String?, copyFromURL: URL?, password: String?) {
        if profileName.isEmpty {
            UIAlertController.showWithTitle("", message: String(localized: "login_enter_username_and_profile"), retryBlock: nil)
            return
        }

        let profileManager = ProfileManager()

        do {
            try profileManager.createProfileWithName(profileName, copyFromURL: copyFromURL)
        }
        catch let error as NSError {
            UIAlertController.showErrorWithMessage(String(localized: error.localizedDescription), retryBlock: nil)
            return
        }

        loginWithProfile(profileName, password: password, configurationClosure: {
            if let name = username {
                _ = try? $0.user.setUserName(name)
                _ = try? $0.user.setUserStatusMessage(String(localized: "default_user_status_message"))
            }
        }, errorClosure: { [unowned self] error in
            let code = OCTManagerInitError(rawValue: error.code)

            if code == .createToxEncrypted {
                UserDefaultsManager().lastActiveProfile = profileName

                let controller = self.createFormController()
                let root = self.navigationController.viewControllers[0]

                self.navigationController.setViewControllers([root, controller], animated: true)
            }
            else {
                handleErrorWithType(.createOCTManager, error: error)
                _ = try? profileManager.deleteProfileWithName(profileName)
            }
        })
    }
}
