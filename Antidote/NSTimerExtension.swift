//
//  NSTimerExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 20.01.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

private class BlockWrapper<T> {
    let block: T

    init(block: T) {
        self.block = block
    }
}

extension Timer {
    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval, block: (Timer) -> Void, repeats: Bool) -> Timer {
        let userInfo = BlockWrapper(block: block)

        return scheduledTimer(timeInterval: interval, target: self, selector: #selector(Timer.executeBlock(_:)), userInfo: userInfo, repeats: repeats)
    }

    static func executeBlock(_ timer: Timer) {
        guard let wrapper = timer.userInfo as? BlockWrapper<(Timer) -> Void> else {
            return
        }

        wrapper.block(timer)
    }
}
