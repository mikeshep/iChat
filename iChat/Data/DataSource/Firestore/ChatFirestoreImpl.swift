//
//  ChatFirestoreImpl.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation
import FirebaseFirestore
import Combine

struct ChatFirestoreImpl: ChatRepository {

    private let db = Firestore.firestore()

    func sendMessage(text: String, for chatId: String, userUid: String) async throws {
        let fields: [AnyHashable: Any] = [
            "createdAt": Date(),
            "messages": FieldValue.arrayUnion(
                [[
                    "id": UUID().uuidString,
                    "text": text,
                    "senderId": userUid,
                    "createdAt": Date()
                ]]
            )
        ]

        try await db.collection("chats").document(chatId).updateData(fields)
    }

    func getChatListener(for chatId: String) -> AnyPublisher<[ChatMessage], Error> {
        return db
            .collection("chats")
            .document(chatId)
            .snapshotPublisher(includeMetadataChanges: true)
            .tryCompactMap {
                try $0.data(as: Chat.self).messages
            }
            .eraseToAnyPublisher()
    }

    func setupChat(userUid: String, contactUid: String) async throws -> String {
        let chatsRef = db.collection("chats")
        let userChastRef = db.collection("userChats")

        let doc = try await userChastRef.document(userUid).getDocument()
        let userChats = try doc.data(as: UserChats.self)

        let chat = userChats.chats?.first { $0.receiverId == contactUid }

        guard chat == nil else {
            return chat!.chatId
        }

        let newChatRef = chatsRef.document()
        let newChat = Chat(createdAt: Date(), messages: [])
        try await newChatRef.setData(from: newChat).value
        let newChatId = newChatRef.documentID

        let fields00: [AnyHashable: Any] = [
            "chats": FieldValue.arrayUnion(
                [[
                    "chatId": newChatId,
                    "lastMessage": "",
                    "receiverId": userUid,
                    "updatedAt": Date()
                ]]
            )
        ]
        try await userChastRef.document(contactUid).updateData(fields00)

        let fields01: [AnyHashable: Any] = [
            "chats": FieldValue.arrayUnion(
                [[
                    "chatId": newChatId,
                    "lastMessage": "",
                    "receiverId": contactUid,
                    "updatedAt": Date()
                ]]
            )
        ]
        try await userChastRef.document(userUid).updateData(fields01)
        return newChatId
    }
}
