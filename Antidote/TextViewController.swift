//
//  TextViewController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 26/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let Offset = 10.0
    static let TitleColorKey = "TITLE_COLOR"
    static let TextColorKey = "TEXT_COLOR"
}

class TextViewController: UIViewController {
    fileprivate let resourceName: String
    fileprivate let backgroundColor: UIColor
    fileprivate let titleColor: UIColor
    fileprivate let textColor: UIColor

    fileprivate var textView: UITextView!

    init(resourceName: String, backgroundColor: UIColor, titleColor: UIColor, textColor: UIColor) {
        self.resourceName = resourceName
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.textColor = textColor

        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        loadViewWithBackgroundColor(backgroundColor)

        createTextView()
        installConstraints()

        loadHtml()
    }
}

private extension TextViewController {
    func createTextView() {
        textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        view.addSubview(textView)
    }

    func installConstraints() {
        textView.snp.makeConstraints {
            $0.leading.top.equalTo(view).offset(Constants.Offset)
            $0.trailing.bottom.equalTo(view).offset(-Constants.Offset)
        }
    }

    func loadHtml() {
        do {
            struct FakeError: Error {}
            guard let htmlFilePath = Bundle.main.path(forResource: resourceName, ofType: "html") else {
                throw FakeError()
            }

            var htmlString = try NSString(contentsOfFile: htmlFilePath, encoding: String.Encoding.utf8.rawValue)
            htmlString = htmlString.replacingOccurrences(of: Constants.TitleColorKey, with: titleColor.hexString()) as NSString
            htmlString = htmlString.replacingOccurrences(of: Constants.TextColorKey, with: textColor.hexString()) as NSString

            guard let data = htmlString.data(using: String.Encoding.unicode.rawValue) else {
                throw FakeError()
            }
            let options = [ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType ]

            try textView.attributedText = NSAttributedString(data: data, options: options, documentAttributes: nil)
        }
        catch {
            handleErrorWithType(.cannotLoadHTML)
        }
    }
}
