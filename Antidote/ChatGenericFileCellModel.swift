//
//  ChatGenericFileCellModel.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 25.03.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

class ChatGenericFileCellModel: ChatMovableDateCellModel {
    enum State {
        case waitingConfirmation
        case loading
        case paused
        case cancelled
        case done
    }

    var state: State = .waitingConfirmation
    var fileName: String?
    var fileSize: String?
    var fileUTI: String?

    var startLoadingHandle: ((Void) -> Void)?
    var cancelHandle: ((Void) -> Void)?
    var retryHandle: ((Void) -> Void)?
    var pauseOrResumeHandle: ((Void) -> Void)?
    var openHandle: ((Void) -> Void)?
}
