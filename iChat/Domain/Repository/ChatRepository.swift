//
//  ChatRepository.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import Combine

protocol ChatRepository {
    func sendMessage(text: String, for chatId: String, userUid: String) async throws
    func getChatListener(for chatId: String) -> AnyPublisher<[ChatMessage], Error>
    func setupChat(userUid: String, contactUid: String) async throws -> String
}
