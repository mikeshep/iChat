//
//  UserFirestoreImpl.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

struct UserFirestoreImpl: UserRepository {

    private let db = Firestore.firestore()

    func creteUser(email: String, password: String) async throws -> String {
        return try await Auth.auth().createUser(withEmail: email, password: password).user.uid
    }

    func saveUser(uid: String, displayName: String, email: String) async throws {
        let user = User(uid: uid,
                        displayName: displayName,
                        email: email)

        let usersRef = db.users.document(user.uid)
        try await usersRef.setData(from: user).value

        let ref = db.userChats.document(user.uid)
        let dataUserChats = UserChats(chats: [])

        try await ref.setData(from: dataUserChats, encoder: Firestore.Encoder()).value
    }

    func login(email: String, password: String) async throws -> String {
        try await Auth.auth().signIn(withEmail: email, password: password).user.uid
    }

    func getUser(uid: String) async throws -> User {
        try await db.collection("users").document(uid).getDocument(as: User.self)
    }

    func searchUser(with email: String, or displayName: String) async throws -> [User] {
        let query = db.collection("users").whereFilter(Filter.orFilter([
            Filter.whereField("email", isEqualTo: email),
            Filter.whereField("displayName", isEqualTo: displayName)
        ]))

        return try await query.getDocuments().documents.compactMap { try? $0.data(as: User.self) }
    }

    func getContacts(uid: String) -> AnyPublisher<[UserChat], Error> {
        db
            .collection("userChats")
            .document(uid)
            .snapshotPublisher()
            .tryCompactMap { try $0.data(as: UserChats.self).chats }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func saveContact() {

    }

    func searchContact() {

    }
}

protocol FirestoreIChat {

}

extension Firestore {
    var users: CollectionReference {
        collection("users")
    }

    var userChats: CollectionReference {
        collection("userChats")
    }
}

enum AsyncError: Error {
    case finishedWithoutValue
}

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: AsyncError.finishedWithoutValue)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
