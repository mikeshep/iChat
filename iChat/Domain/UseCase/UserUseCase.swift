//
//  UserUseCase.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

struct UserUseCase: UserRepository {
    var repo: UserRepository

    func searchUser(with email: String, or displayName: String) async throws -> [User] {
        try await repo.searchUser(with: email, or: displayName)
    }

    func creteUser(email: String, password: String) async throws -> String {
        try await repo.creteUser(email: email, password: password)
    }

    func saveUser(uid: String, displayName: String, email: String) async throws {
        try await repo.saveUser(uid: uid, displayName: displayName, email: email)
    }

    func login(email: String, password: String) async throws -> String {
        try await repo.login(email: email, password: password)
    }

    func getUser(uid: String) async throws -> User {
        try await repo.getUser(uid: uid)
    }

    func getContacts(uid: String) -> AnyPublisher<[UserChat], Error> {
        repo.getContacts(uid: uid)
    }

    func saveContact() {
        repo.saveContact()
    }

    func searchContact() {
        repo.searchContact()
    }
}
