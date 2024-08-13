//
//  ChatViewModel.swift
//  FoodNinja
//
//  Created by Miguel Olmedo on 09/08/24.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var chatId: String = ""
    @Published var password: String = ""
    @Published var alertMessageError = ""
    @Published var showingAlert = false
    @Published var messages: [ChatMessage] = []
    private var subscriptions = Set<AnyCancellable>()
    var chatUseCase = ChatUseCase(repo: ChatRepositoryImpl(dataSource: ChatFirestoreImpl()))

    deinit {
        debugPrint("")
    }

    func onDisappear() {
        subscriptions.removeAll()
    }

    func sendMessage(contact: UserUid, text: String, user: UserInfo) async {
        do {
            try await chatUseCase.sendMessage(text: text, for: chatId, userUid: user.uid)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchChat(contact: UserUid, user: UserInfo, chatId: String) {
        self.chatId = chatId
        chatUseCase
            .getChatListener(for: chatId)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.messages, on: self)
            .store(in: &subscriptions)
    }

    func setupChat(contact: UserUid, user: UserInfo) async -> String {
        do {
            return try await chatUseCase.setupChat(userUid: user.uid, contactUid: contact.uid)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
