//
//  PinAuthorizationCoordinator.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02/09/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation
import AudioToolbox
import LocalAuthentication

class PinAuthorizationCoordinator: NSObject {
    fileprivate enum State {
        case unlocked
        case locked(lockTime: CFTimeInterval)
        case validatingPin
    }

    fileprivate let theme: Theme
    fileprivate let window: UIWindow

    fileprivate weak var submanagerObjects: OCTSubmanagerObjects!

    fileprivate var state: State

    init(theme: Theme, submanagerObjects: OCTSubmanagerObjects, lockOnStartup: Bool) {
        self.theme = theme
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.submanagerObjects = submanagerObjects
        self.state = .unlocked

        super.init()

        // Showing window on top of all other windows.
        window.windowLevel = UIWindowLevelStatusBar + 1000

        if lockOnStartup {
            lockIfNeeded(0)
        }

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(PinAuthorizationCoordinator.appWillResignActiveNotification),
                                                         name: NSNotification.Name.UIApplicationWillResignActive,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(PinAuthorizationCoordinator.appDidBecomeActiveNotification),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                         object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func appWillResignActiveNotification() {
        lockIfNeeded(CACurrentMediaTime())
    }

    func appDidBecomeActiveNotification() {
        switch state {
            case .unlocked:
                // unlocked, nothing to do here
                break
            case .locked(let lockTime):
                isPinDateExpired(lockTime) ? challengeUserToAuthorize(lockTime) : unlock()
            case .validatingPin:
                // checking pin, no action required
                break
        }
    }
}

extension PinAuthorizationCoordinator: CoordinatorProtocol {
    func startWithOptions(_ options: CoordinatorOptions?) {
        switch state {
            case .locked(let lockTime):
                challengeUserToAuthorize(lockTime)
            default:
                // ignore
                break
        }
    }
}

extension PinAuthorizationCoordinator: EnterPinControllerDelegate {
    func enterPinController(_ controller: EnterPinController, successWithPin pin: String) {
        unlock()
    }

    func enterPinControllerFailure(_ controller: EnterPinController) {
        controller.resetEnteredPin()
        controller.topText = String(localized: "pin_incorrect")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

private extension PinAuthorizationCoordinator {
    func lockIfNeeded(_ lockTime: CFTimeInterval) {
        guard submanagerObjects.getProfileSettings().unlockPinCode != nil else {
            return
        }

        let storyboard = UIStoryboard(name: "LaunchPlaceholderBoard", bundle: Bundle.main)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "LaunchPlaceholderController")
        window.isHidden = false

        switch state {
            case .unlocked:
                // In case of Locked state don't want to update lockTime.
                // In case of ValidatingPin state we also don't want to do anything.
                state = .locked(lockTime: lockTime)
            default:
                break
        }
    }

    func unlock() {
        state = .unlocked
        window.isHidden = true
    }

    func challengeUserToAuthorize(_ lockTime: CFTimeInterval) {
        if window.rootViewController is EnterPinController {
            // already showing pin controller
            return
        }

        if shouldUseTouchID() {
            state = .validatingPin

            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: String(localized: "pin_touch_id_description"),
                                       reply: { [weak self] success, error in
                DispatchQueue.main.async {
                    self?.state = .locked(lockTime: lockTime)

                    success ? self?.unlock() : self?.showValidatePinController()
                }
            })
        }
        else {
            showValidatePinController()
        }
    }

    func showValidatePinController() {
        let settings = submanagerObjects.getProfileSettings()
        guard let pin = settings.unlockPinCode else {
            fatalError("pin shouldn't be nil")
        }

        let controller = EnterPinController(theme: theme, state: .validatePin(validPin: pin))
        controller.topText = String(localized: "pin_enter_to_unlock")
        controller.delegate = self
        window.rootViewController = controller
    }

    func isPinDateExpired(_ lockTime: CFTimeInterval) -> Bool {
        let settings = submanagerObjects.getProfileSettings()
        let delta = CACurrentMediaTime() - lockTime

        switch settings.lockTimeout {
            case .Immediately:
                return true
            case .Seconds30:
                return delta > 30
            case .Minute1:
                return delta > 60
            case .Minute2:
                return delta > (60 * 2)
            case .Minute5:
                return delta > (60 * 5)
        }
    }

    func shouldUseTouchID() -> Bool {
        guard submanagerObjects.getProfileSettings().useTouchID else {
            return false
        }

        guard LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return false
        }

        return true
    }
}
