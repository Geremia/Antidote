//
//  NSURLExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 29.03.16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation
import MobileCoreServices

extension URL {
    func isToxURL() -> Bool {
        guard isFileURL else {
            return false
        }

        let request = URLRequest(url: self, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 0.1)
        var response: URLResponse? = nil

        _ = try? NSURLConnection.sendSynchronousRequest(request, returning: &response)

        guard let mimeType = response?.mimeType else {
            return false
        }

        guard let identifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }

        return UTTypeEqual(identifier, kUTTypeData)
    }
}
