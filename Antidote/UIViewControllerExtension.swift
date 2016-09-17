//
//  UIViewControllerExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

extension UIViewController {
    func loadViewWithBackgroundColor(_ backgroundColor: UIColor) {
        let frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)

        view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
    }
}
