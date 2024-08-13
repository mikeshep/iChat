//
//  LoginViewModel.swift
//  FoodNinja
//
//  Created by Imran on 01/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error = ""
    @Published var showingAlert = false
    @Published var isAuthenticated = false {
        didSet {
            debugPrint(isAuthenticated)
        }
    }

    var userUseCase = UserUseCase(repo: UserRepositoryImpl(dataSource: UserFirestoreImpl()))

    func login(user: UserInfo) async {
        do {
            let result = try await userUseCase.login(email: email, password: password)
            let u = try await userUseCase.getUser(uid: result)

            user.uid = u.uid
            user.displayName = u.displayName
            self.isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
            isAuthenticated = false
            showingAlert = true
        }
    }
}
