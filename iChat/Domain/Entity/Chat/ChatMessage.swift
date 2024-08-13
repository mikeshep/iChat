//
//  ChatMessage.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//
import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    var id: String
    var text: String
    var senderId: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case senderId
        case createdAt
    }
}
