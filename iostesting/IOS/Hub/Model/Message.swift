//
//  Message.swift
//  Hub
//
//  Created by John Robert Prince on 26.04.2025.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    var id = UUID()
//    let fromID: String
//    let toID: String
    let messageText: String
//    let timesTamp: Date
    let isFromCurrentUser: Bool
    
    //var user: User?
}
