//
//  UserRepositoryImpl.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

struct UserRepositoryImpl: UserRepository {

    var dataSource: UserRepository

    func searchUser(with email: String, or displayName: String) async throws -> [User] {
        try await dataSource.searchUser(with: email, or: displayName)
    }

    func getUser(uid: String) async throws -> User {
        try await dataSource.getUser(uid: uid)
    }

    func creteUser(email: String, password: String) async throws -> String {
        try await dataSource.creteUser(email: email, password: password)
    }

    func saveUser(uid: String, displayName: String, email: String) async throws {
        try await dataSource.saveUser(uid: uid, displayName: displayName, email: email)
    }

    func login(email: String, password: String) async throws -> String {
        try await dataSource.login(email: email, password: password)
    }

    func getContacts(uid: String) -> AnyPublisher<[UserChat], Error> {
        dataSource.getContacts(uid: uid)
    }

    func saveContact() {

    }

    func searchContact() {

    }
}
