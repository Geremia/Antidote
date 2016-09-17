//
//  PortraitNavigationController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 13/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

class PortraitNavigationController: UINavigationController {
    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
