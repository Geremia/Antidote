//
//  LoginLogoController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct PrivateConstants {
    static let LogoTopOffset = -200.0
    static let LogoHeight = 100.0
}

class LoginLogoController: LoginBaseController {
    /**
     * Main view, which is used as container for all subviews.
     */
    var mainContainerView: UIView!
    var mainContainerViewTopConstraint: Constraint?

    var logoImageView: UIImageView!

    /**
     * Use this container to add subviews in subclasses.
     * Is placed under logo.
     */
    var contentContainerView: UIView!

    override func loadView() {
        super.loadView()

        createMainContainerView()
        createLogoImageView()
        createContainerView()

        installConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated:animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated:animated)
    }
}

private extension LoginLogoController {
    func createMainContainerView() {
        mainContainerView = UIView()
        mainContainerView.backgroundColor = .clear
        view.addSubview(mainContainerView)
    }

    func createLogoImageView() {
        let image = UIImage.templateNamed("login-logo")

        logoImageView = UIImageView(image: image)
        logoImageView.tintColor = theme.colorForType(.LoginToxLogo)
        logoImageView.contentMode = .scaleAspectFit
        mainContainerView.addSubview(logoImageView)
    }

    func createContainerView() {
        contentContainerView = UIView()
        contentContainerView.backgroundColor = .clear
        mainContainerView.addSubview(contentContainerView)
    }

    func installConstraints() {
        mainContainerView.snp.makeConstraints {
            mainContainerViewTopConstraint = $0.top.equalTo(view).constraint
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(view)
        }

        logoImageView.snp.makeConstraints {
            $0.centerX.equalTo(mainContainerView)
            $0.top.equalTo(mainContainerView.snp.centerY).offset(PrivateConstants.LogoTopOffset)
            $0.height.equalTo(PrivateConstants.LogoHeight)
        }

        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.VerticalOffset)
            $0.bottom.equalTo(mainContainerView)
            $0.leading.trailing.equalTo(mainContainerView)
        }
    }
}
