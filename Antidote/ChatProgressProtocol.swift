//
//  ChatProgressProtocol.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 22.03.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

protocol ChatProgressProtocol {
    var updateProgress: ((_ progress: Float) -> Void)? { get set }
    var updateEta: ((_ eta: CFTimeInterval, _ bytesPerSecond: OCTToxFileSize) -> Void)? { get set }
}
