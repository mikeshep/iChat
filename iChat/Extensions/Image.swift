//
//  Image.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import SwiftUI

enum ImageName: String {
    case splash, splashLogo, facebook,
         google, lock, message, profile,
         backIcon, payoneer, paypal, visa,
         conversations, power, chat
    case onboarding1 = "onboarding-1"
    case onboarding2 = "onboarding-2"

    case person = "person.fill"
    case eye = "eye"
    case eyeSlash = "eye.slash"
    case checkMarkFilled = "checkmark.circle.fill"
    case checkmark = "checkmark.circle"
    case searchIcon = "search-icon"
    case headerChat = "header-chat"
}

extension Image {
    init(name: ImageName) {
        self.init(name.rawValue)
    }

    init(sysNameImage: ImageName) {
        self.init(systemName: sysNameImage.rawValue)
    }
}
