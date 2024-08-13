//
//  AppDelegate+Deeplinks.swift
//  iChat
//
//  Created by Miguel Olmedo on 13/08/24.
//

import Foundation
import UIKit

extension AppDelegate {
    func processFromWebPageURL(_ userActivity: NSUserActivity) {
        UniversalLinkProcess.shared(with: self).processFromWebPageURL(userActivity)
    }

    func processFromScheme(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) {
        UniversalLinkProcess.shared(with: self).processFromScheme(url, options: options)
    }

    func open(path: String, utmParameters: [String: Any]? = nil) {
        guard let url = URL(string: path) else {
            debugPrint("Unable to create a url from deeplink value")
            return
        }

        let routePath = url.pathComponents[1]

       debugPrint(routePath)
    }
}
