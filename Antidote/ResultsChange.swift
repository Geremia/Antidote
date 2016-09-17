//
//  ResultsChange.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/07/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

/// Swift wrapper for RLMResults addNotificationBlock.
enum ResultsChange<T: OCTObject> {
    case initial(Results<T>?)
    case update(Results<T>?, deletions: [Int], insertions: [Int], modifications: [Int])
    case error(NSError)
}
