//
//  ChatUseCase.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

struct ChatUseCase: ChatRepository {
    var repo: ChatRepository

    func sendMessage(text: String, for chatId: String, userUid: String) async throws {
        try await repo.sendMessage(text: text, for: chatId, userUid: userUid)
    }

    func getChatListener(for chatId: String) -> AnyPublisher<[ChatMessage], Error> {
        repo.getChatListener(for: chatId)
    }

    func setupChat(userUid: String, contactUid: String) async throws -> String {
        try await repo.setupChat(userUid: userUid, contactUid: contactUid)
    }
}
