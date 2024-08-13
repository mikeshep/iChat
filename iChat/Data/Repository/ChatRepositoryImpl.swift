//
//  ChatRepositoryImpl.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

struct ChatRepositoryImpl: ChatRepository {

    var dataSource: ChatRepository

    func sendMessage(text: String, for chatId: String, userUid: String) async throws {
        try await dataSource.sendMessage(text: text, for: chatId, userUid: userUid)
    }
    func getChatListener(for chatId: String) -> AnyPublisher<[ChatMessage], Error> {
        dataSource.getChatListener(for: chatId)
    }
    func setupChat(userUid: String, contactUid: String) async throws -> String {
        try await dataSource.setupChat(userUid: userUid, contactUid: contactUid)
    }
}
