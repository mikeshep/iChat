//
//  Chat.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation

struct Chat: Codable {
    let createdAt: Date
    let messages: [ChatMessage]
}
