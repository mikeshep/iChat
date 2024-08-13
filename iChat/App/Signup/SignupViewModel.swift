//
//  SignupViewModel.swift
//  FoodNinja
//
//  Created by Imran on 19/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var keepMeSignedIn = false
    @Published var error = ""
    @Published var showingAlert = false
    @Published var isAuthenticated = false

    var userUseCase = UserUseCase(repo: UserRepositoryImpl(dataSource: UserFirestoreImpl()))

    func signUp(user: UserInfo) async {
        do {
            let uid = try await userUseCase.creteUser(email: email, password: password)
            try await userUseCase.saveUser(uid: uid, displayName: username, email: email)
            self.isAuthenticated = true
            user.uid = uid
            user.displayName = username
        } catch {
            self.error = error.localizedDescription
            self.showingAlert = true
        }
    }
}
