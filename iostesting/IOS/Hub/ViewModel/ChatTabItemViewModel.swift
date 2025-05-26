//
//  ChatTabItemViewModel.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import Foundation

final class ChatTabItemViewModel: ObservableObject {
    @Published var allChats: [User] = Constants.allUsers
    @Published var groups: [String: [User]] = ["Все" : Constants.allUsers, "Избранное": []]
    
    let mockData: [User: [Message]] = [
        Constants.tonyStark : [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false),
            Message(messageText: "6", isFromCurrentUser: false),
            Message(messageText: "7", isFromCurrentUser: true)
        ],
        Constants.batman : [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: true)
        ],
        Constants.margoRobby : [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false),
            Message(messageText: "6", isFromCurrentUser: false),
            Message(messageText: "7", isFromCurrentUser: true),
            Message(messageText: "8", isFromCurrentUser: true)
        ],
        Constants.jasonStatham : [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false)
        ],
        Constants.arnold : [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false)
        ]
    ]
    
    let users: [User] = [
        Constants.tonyStark,
        Constants.batman,
        Constants.margoRobby,
        Constants.jasonStatham,
        Constants.arnold
    ]
    
    let messages: [[Message]] = [
        [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false),
            Message(messageText: "6", isFromCurrentUser: false),
            Message(messageText: "7", isFromCurrentUser: true)
        ],
        [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: true)
        ],
        [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false),
            Message(messageText: "6", isFromCurrentUser: false),
            Message(messageText: "7", isFromCurrentUser: true),
            Message(messageText: "8", isFromCurrentUser: true)
        ],
        [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false)
        ],
        [
            Message(messageText: "1", isFromCurrentUser: true),
            Message(messageText: "2", isFromCurrentUser: false),
            Message(messageText: "3", isFromCurrentUser: true),
            Message(messageText: "4", isFromCurrentUser: false),
            Message(messageText: "5", isFromCurrentUser: false)
        ]
    ]
}
