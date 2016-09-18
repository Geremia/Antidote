//
//  LoginBaseController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

class LoginBaseController: KeyboardNotificationController {
    struct Constants {
        static let HorizontalOffset = 40.0
        static let VerticalOffset = 40.0
        static let SmallVerticalOffset = 8.0

        static let TextFieldHeight: CGFloat = 40.0

        static let MaxFormWidth = 350.0
    }

    let theme: Theme

    init(theme: Theme) {
        self.theme = theme

        super.init()

        edgesForExtendedLayout = UIRectEdge()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        loadViewWithBackgroundColor(theme.colorForType(.LoginBackground))
    }
}
