//
//  ExtendedTextField.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 27/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let TextFieldHeight = 40.0
    static let VerticalOffset = 5.0
}

protocol ExtendedTextFieldDelegate: class {
    func loginExtendedTextFieldReturnKeyPressed(_ field: ExtendedTextField)
}

class ExtendedTextField: UIView {
    enum FieldType {
        case login
        case normal
    }

    weak var delegate: ExtendedTextFieldDelegate?

    var maxTextUTF8Length: Int = Int.max

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    var hint: String? {
        get {
            return hintLabel.text
        }
        set {
            hintLabel.text = newValue
        }
    }

    var secureTextEntry: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }

    var returnKeyType: UIReturnKeyType {
        get {
            return textField.returnKeyType
        }
        set {
            textField.returnKeyType = newValue
        }
    }

    fileprivate var titleLabel: UILabel!
    fileprivate var textField: UITextField!
    fileprivate var hintLabel: UILabel!

    init(theme: Theme, type: FieldType) {
        super.init(frame: CGRect.zero)

        createViews(theme: theme, type: type)
        installConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
}

extension ExtendedTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.loginExtendedTextFieldReturnKeyPressed(self)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if resultText.lengthOfBytes(using: String.Encoding.utf8) <= maxTextUTF8Length {
            return true
        }

        textField.text = resultText.substringToByteLength(maxTextUTF8Length, encoding: String.Encoding.utf8)
        return false
    }
}

private extension ExtendedTextField {
    func createViews(theme: Theme, type: FieldType) {
        let textColor: UIColor

        switch type {
            case .login:
                textColor = theme.colorForType(.LoginDescriptionLabel)
            case .normal:
                textColor = theme.colorForType(.NormalText)
        }

        titleLabel = UILabel()
        titleLabel.textColor = textColor
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.backgroundColor = .clear
        addSubview(titleLabel)

        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .sentences
        textField.enablesReturnKeyAutomatically = true
        addSubview(textField)

        hintLabel = UILabel()
        hintLabel.textColor = textColor
        hintLabel.font = UIFont.antidoteFontWithSize(14.0, weight: .light)
        hintLabel.numberOfLines = 0
        hintLabel.backgroundColor = .clear
        addSubview(hintLabel)
    }

    func installConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.VerticalOffset)
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(Constants.TextFieldHeight)
        }

        hintLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(Constants.VerticalOffset)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }
}
