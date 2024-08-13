//
//  UserChat.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import FirebaseFirestore

struct UserChat: Codable {
    @DocumentID var id: String?
    let receiverId: String
    var updatedAt: Date
    var lastMessage: String
    let chatId: String
}
