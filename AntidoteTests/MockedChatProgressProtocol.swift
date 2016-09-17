//
//  MockedChatProgressProtocol.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02.04.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

class MockedChatProgressProtocol: ChatProgressProtocol {
    var updateProgress: ((_ progress: Float) -> Void)?
    var updateEta: ((_ eta: CFTimeInterval, _ bytesPerSecond: OCTToxFileSize) -> Void)?
}
