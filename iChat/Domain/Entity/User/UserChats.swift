//
//  UserChat.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import FirebaseFirestore

struct UserChats: Codable {
    @DocumentID var id: String?
    var chats: [UserChat]?
}
