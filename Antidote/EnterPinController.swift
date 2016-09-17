//
//  EnterPinController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02/09/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation
import SnapKit

private struct Constants {
    static let PinLength = 4
}

protocol EnterPinControllerDelegate: class {
    func enterPinController(_ controller: EnterPinController, successWithPin pin: String)

    // This method may be called only for ValidatePin state.
    func enterPinControllerFailure(_ controller: EnterPinController)
}

class EnterPinController: UIViewController {
    enum State {
        case validatePin(validPin: String)
        case setPin
    }

    weak var delegate: EnterPinControllerDelegate?

    let state: State

    var topText: String {
        get {
            return pinInputView.topText
        }
        set {
            if #available(iOS 9.0, *) {
                loadViewIfNeeded()
            } else {
                if !isViewLoaded {
                    // creating view
                    view.setNeedsDisplay()
                }
            }

            pinInputView.topText = newValue
        }
    }

    fileprivate let theme: Theme

    fileprivate var pinInputView: PinInputView!

    fileprivate var enteredString: String = ""

    init(theme: Theme, state: State) {
        self.theme = theme
        self.state = state

        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        loadViewWithBackgroundColor(theme.colorForType(.NormalBackground))

        createViews()
        installConstraints()

        pinInputView.applyColors()
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func resetEnteredPin() {
        enteredString = ""
        pinInputView.enteredNumbersCount = enteredString.characters.count
    }
}

extension EnterPinController: PinInputViewDelegate {
    func pinInputView(_ view: PinInputView, numericButtonPressed i: Int) {
        guard enteredString.characters.count < Constants.PinLength else {
            return
        }

        enteredString += "\(i)"
        pinInputView.enteredNumbersCount = enteredString.characters.count

        if enteredString.characters.count == Constants.PinLength {
            switch state {
                case .validatePin(let validPin):
                     if enteredString == validPin {
                         delegate?.enterPinController(self, successWithPin: enteredString)
                     }
                     else {
                         delegate?.enterPinControllerFailure(self)
                     }
                case .setPin:
                    delegate?.enterPinController(self, successWithPin: enteredString)
            }
        }
    }

    func pinInputViewDeleteButtonPressed(_ view: PinInputView) {
        guard enteredString.characters.count > 0 else {
            return
        }

        enteredString = String(enteredString.characters.dropLast())
        view.enteredNumbersCount = enteredString.characters.count
    }
}

private extension EnterPinController {
    func createViews() {
        pinInputView = PinInputView(pinLength: Constants.PinLength, topColor: .green, bottomColor: .blue)
        pinInputView.delegate = self
        view.addSubview(pinInputView)
    }

    func installConstraints() {
        pinInputView.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
}
