//
//  AppState.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import SwiftUI

enum AppStorageKey: String {
    case isOnboardingDone
    case user
    case isAuthenticated
}

final class AppState: ObservableObject {
    @AppStorage(AppStorageKey.isAuthenticated.rawValue) var isAuthenticated: Bool = false {
        didSet {
            debugPrint(isAuthenticated)
        }
    }
}

enum UserInfoKey: String {
    case uid
    case displayName
}

final class UserInfo: ObservableObject {
    @AppStorage(UserInfoKey.uid.rawValue) var uid: String = ""
    @AppStorage(UserInfoKey.displayName.rawValue) var displayName: String = ""
}
