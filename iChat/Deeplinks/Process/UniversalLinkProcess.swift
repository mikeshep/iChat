//
//  UniversalLinkProcess.swift
//  iChat
//
//  Created by Miguel Olmedo on 13/08/24.
//

import Foundation
import UIKit

final class UniversalLinkProcess: DeepLinkProcess {
    private let delegate: AppDelegate
    private static var _shared: UniversalLinkProcess?

    private init(with delegate: AppDelegate) {
        self.delegate = delegate
    }

    static func shared(with delegate: AppDelegate?) -> UniversalLinkProcess {
        guard let shared = UniversalLinkProcess._shared else {
            UniversalLinkProcess._shared = UniversalLinkProcess(with: delegate!)
            return UniversalLinkProcess._shared!
        }

        return shared
    }

    func processFromWebPageURL(_ userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else {
            return
        }
        self.delegate.open(path: url.absoluteString)
    }

    func processFromScheme(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) {
        self.delegate.open(path: url.absoluteString)
    }
}
