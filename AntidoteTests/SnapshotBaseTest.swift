//
//  SnapshotBaseTest.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02.04.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import XCTest

class SnapshotBaseTest: FBSnapshotTestCase {
    var theme: Theme!

    var image: UIImage {
        get {
            let bundle = Bundle(for: type(of: self))
            return UIImage(named: "icon", in:bundle, compatibleWith: nil)!
        }
    }

    override func setUp() {
        super.setUp()

        let filepath = Bundle.main.path(forResource: "default-theme", ofType: "yaml")!
        let yamlString = try! NSString(contentsOfFile:filepath, encoding:String.Encoding.utf8.rawValue) as String

        theme = try! Theme(yamlString: yamlString)
    }

    func verifyView(_ view: UIView) {
        FBSnapshotVerifyView(view, identifier: "normal")

        view.forceRightToLeft()
        FBSnapshotVerifyView(view, identifier: "right-to-left")
    }
}

private extension UIView {
    func forceRightToLeft() {
        if #available(iOS 9.0, *) {
            semanticContentAttribute = .forceRightToLeft
        }

        for view in subviews {
            view.forceRightToLeft()
        }
    }
}
