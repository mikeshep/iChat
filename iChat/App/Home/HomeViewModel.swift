//
//  HomeViewModel.swift
//  FoodNinja
//
//  Created by Miguel Olmedo on 08/08/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    var userUseCase = UserUseCase(repo: UserRepositoryImpl(dataSource: UserFirestoreImpl()))

    @Published var searchText: String = "" {
        willSet {
            Task {
                self.findUsers = await self.searchUser(with: newValue, or: newValue)
            }
        }
    }

    @Published var contacts: [User] = []
    var filteredContacts: [User] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.displayName.lowercased().contains(searchText.lowercased()) }
        }
    }

    @Published var findUsers: [User] = []
    var filteredFindUsers: [User] {
        return findUsers
    }

    var findContacts: [UserChat] = [] {
        didSet {
            Task {
                var contacts = [User]()
                for userChat in findContacts {
                    do {
                        var user = try await userUseCase.getUser(uid: userChat.receiverId)
                        user.lastMessage = userChat.lastMessage
                        contacts.append(user)
                    } catch {
                        debugPrint(error)
                    }
                }
                await MainActor.run {
                    self.contacts = contacts
                }
            }
        }
    }

    func getContacts(user: UserInfo) {
        userUseCase
            .getContacts(uid: user.uid)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.findContacts, on: self)
            .store(in: &subscriptions)
    }

    func searchUser(with email: String, or displayName: String) async -> [User] {
        do {
            let users = try await userUseCase.searchUser(with: email, or: displayName)
            return users
        } catch {
            return []
        }
    }
}
