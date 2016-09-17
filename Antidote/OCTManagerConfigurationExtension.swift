//
//  OCTManagerConfigurationExtension.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 19/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

extension OCTManagerConfiguration {
    static func configurationWithBaseDirectory(_ baseDirectory: String) -> OCTManagerConfiguration? {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: baseDirectory, isDirectory:&isDirectory)

        guard exists && isDirectory.boolValue else {
            return nil
        }

        let configuration = OCTManagerConfiguration.default()

        let userDefaultsManager = UserDefaultsManager()

        configuration.options.iPv6Enabled = userDefaultsManager.IPv6Enabled
        configuration.options.udpEnabled = userDefaultsManager.UDPEnabled

        configuration.fileStorage = OCTDefaultFileStorage(baseDirectory: baseDirectory, temporaryDirectory: NSTemporaryDirectory())

        return configuration
    }
}
