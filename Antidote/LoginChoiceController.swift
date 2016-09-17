//
//  LoginChoiceController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginChoiceControllerDelegate: class {
    func loginChoiceControllerCreateAccount(_ controller: LoginChoiceController)
    func loginChoiceControllerImportProfile(_ controller: LoginChoiceController)
}

class LoginChoiceController: LoginLogoController {
    weak var delegate: LoginChoiceControllerDelegate?

    fileprivate var incompressibleContainer: IncompressibleView!
    fileprivate var welcomeLabel: UILabel!
    fileprivate var createAccountButton: RoundedButton!
    fileprivate var orLabel: UILabel!
    fileprivate var importProfileButton: RoundedButton!

    override func loadView() {
        super.loadView()

        createContainer()
        createLabels()
        createButtons()

        installConstraints()
    }
}

// MARK: Actions
extension LoginChoiceController {
    func createAccountButtonPressed() {
        delegate?.loginChoiceControllerCreateAccount(self)
    }

    func importProfileButtonPressed() {
        delegate?.loginChoiceControllerImportProfile(self)
    }
}

private extension LoginChoiceController {
    func createContainer() {
        incompressibleContainer = IncompressibleView()
        incompressibleContainer.backgroundColor = .clear
        contentContainerView.addSubview(incompressibleContainer)
    }

    func createLabels() {
        welcomeLabel = createLabelWithText(String(localized:"login_welcome_text"))
        orLabel = createLabelWithText(String(localized:"login_or_label"))
    }

    func createButtons() {
        createAccountButton = createButtonWithTitle(String(localized:"create_account"), action: #selector(LoginChoiceController.createAccountButtonPressed))
        importProfileButton = createButtonWithTitle(String(localized:"import_profile"), action: #selector(LoginChoiceController.importProfileButtonPressed))
    }

    func installConstraints() {
        incompressibleContainer.customIntrinsicContentSize.width = CGFloat(Constants.MaxFormWidth)
        incompressibleContainer.snp.makeConstraints {
            $0.top.equalTo(contentContainerView)
            $0.centerX.equalTo(contentContainerView)
            $0.width.lessThanOrEqualTo(Constants.MaxFormWidth)
            $0.width.lessThanOrEqualTo(contentContainerView).offset(-2 * Constants.HorizontalOffset)
            $0.height.equalTo(contentContainerView)
        }

        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(incompressibleContainer)
            $0.leading.trailing.equalTo(incompressibleContainer)
        }

        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(Constants.VerticalOffset)
            $0.leading.trailing.equalTo(welcomeLabel)
        }

        orLabel.snp.makeConstraints {
            $0.top.equalTo(createAccountButton.snp.bottom).offset(Constants.SmallVerticalOffset)
            $0.leading.trailing.equalTo(welcomeLabel)
        }

        importProfileButton.snp.makeConstraints {
            $0.top.equalTo(orLabel.snp.bottom).offset(Constants.SmallVerticalOffset)
            $0.leading.trailing.equalTo(welcomeLabel)
        }
    }

    func createLabelWithText(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = theme.colorForType(.LoginDescriptionLabel)
        label.textAlignment = .center
        label.backgroundColor = .clear

        incompressibleContainer.addSubview(label)

        return label
    }

    func createButtonWithTitle(_ title: String, action: Selector) -> RoundedButton {
        let button = RoundedButton(theme: theme, type: .login)
        button.setTitle(title, for: UIControlState())
        button.addTarget(self, action: action, for: .touchUpInside)

        incompressibleContainer.addSubview(button)

        return button
    }
}
