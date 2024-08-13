//
//  AppDelegate.swift
//  iChat
//
//  Created by Miguel Olmedo on 13/08/24.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationManager = AppNotificationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        notificationManager.requestAuthorization { granted in
            debugPrint("granted \(granted)")
        }

        if let activityDictionary = launchOptions?[.userActivityDictionary] as? [UIApplication.LaunchOptionsKey: Any],
            let activityType = activityDictionary[.userActivityType] as? String,
            activityType == NSUserActivityTypeBrowsingWeb {
            return true
        }

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        processFromScheme(url, options: options)
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        processFromWebPageURL(userActivity)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationManager.didRegisterDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        notificationManager.didReceiveRemoteNotification(userInfo)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if userInfo["com.google.firebase.auth"] != nil {
            completionHandler(.noData)
            return
        }
        UIApplication.shared.applicationIconBadgeNumber += 1
        notificationManager.didReceiveRemoteNotification(
            userInfo,
            fetchCompletionHandler: completionHandler
        )
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound])
    }
}
