//
//  Logger.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 07/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

func log (_ string: String, filename: NSString = #file) {
    NSLog("\(filename.lastPathComponent): \(string)")
}

