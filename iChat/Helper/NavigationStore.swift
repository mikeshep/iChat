//
//  NavigationStore.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import SwiftUI

enum NavigationDestination: Hashable {

    case login, signup, home
    case chat(contact: UserUid)

    @ViewBuilder
    var view: some View {
        switch self {
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .home:
            HomeView()
        case let .chat(contact: UserUid):
            ChatView(contact: UserUid)
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .login:
            hasher.combine("login")
        case .signup:
            hasher.combine("signup")
        case .home:
            hasher.combine("home")
        case .chat(let userUid):
            hasher.combine("chat")
            hasher.combine(userUid)
        }
    }
}

final class NavigationStore: ObservableObject {
    @Published var path: [NavigationDestination] = []

    func popToRoot() {
        path.removeAll()
    }

    func popView() {
        path.removeLast()
    }

    func push(to view: NavigationDestination) {
        path.append(view)
    }
}
