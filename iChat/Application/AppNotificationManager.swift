//
//  AppNotificationManager.swift
//  iChat
//
//  Created by Miguel Olmedo on 13/08/24.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import UIKit

class AppNotificationManager: NSObject {
    static let tokenUpdated = Notification.Name("FCMToken")
    private let deeplinkKey = "deeplink"

    static var deviceToken: String {
        Messaging.messaging().fcmToken ?? ""
    }

    public override init() {
        super.init()
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }

    public func requestAuthorization(completion: @escaping (_ granted: Bool) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, _ in
            completion(granted)
        }
    }

    public func setup() {

    }

    private func debugPrint(_ items: Any...) {
        #if DEBUG
        print(items)
        #endif
    }
}

extension AppNotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        NotificationCenter.default.post(
            name: AppNotificationManager.tokenUpdated,
            object: nil,
            userInfo: ["token": fcmToken]
        )
        debugPrint("Firebase token: \(fcmToken)")
    }
}

extension AppNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .banner, .list])
        } else {
            completionHandler([.alert, .sound])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        didReceiveRemoteNotification(userInfo)
        completionHandler()
    }

    func manageUserInfo(_ userInfo: [AnyHashable: Any]) {
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]

        guard
              let link = alert?[deeplinkKey],
              let url = URL(string: link),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.processFromScheme(url)
    }

    func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        guard handleDeepLink(userInfo: userInfo) else {
            manageUserInfo(userInfo)
            return
        }
    }

    func didReceiveRemoteNotification(
        _ userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
    }

    func didRegisterDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    private func handleDeepLink(userInfo: [AnyHashable: Any]) -> Bool {
        guard let data = userInfo["data"] as? [AnyHashable: Any],
              let deeplinkString = data[deeplinkKey] as? String,
              let deeplink = URL(string: deeplinkString),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        appDelegate.processFromScheme(deeplink)
        return true
    }
}
