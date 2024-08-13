//
//  UserId.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import Foundation

class UserUid: ObservableObject, Equatable, Hashable {
    static func == (lhs: UserUid, rhs: UserUid) -> Bool {
        lhs.uid == rhs.uid
    }

    @Published var uid = ""
    @Published var displayName = ""

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(displayName)
    }
}
