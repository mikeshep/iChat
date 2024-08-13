//
//  DeeplinkProcess.swift
//  iChat
//
//  Created by Miguel Olmedo on 13/08/24.
//

import Foundation
import UIKit

protocol DeepLinkProcess {
    static func shared(with delegate: AppDelegate?) -> Self
    func processFromWebPageURL(_ userActivity: NSUserActivity)
    func processFromScheme(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
}

extension DeepLinkProcess {
    func processFromScheme(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) {
        processFromScheme(url, options: options)
    }
}
