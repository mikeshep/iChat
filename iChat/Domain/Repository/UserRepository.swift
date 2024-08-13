//
//  UserRepository.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

protocol UserRepository {
    func creteUser(email: String, password: String) async throws -> String
    func saveUser(uid: String, displayName: String, email: String) async throws
    func login(email: String, password: String) async throws -> String
    func getUser(uid: String) async throws -> User
    func searchUser(with email: String, or displayName: String) async throws -> [User]
    func getContacts(uid: String) -> AnyPublisher<[UserChat], Error>
    func saveContact()
    func searchContact()
}
