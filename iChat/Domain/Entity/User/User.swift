//
//  User.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let displayName: String
    let email: String
    var lastMessage: String?
}
