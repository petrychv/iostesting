//
//  User.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var lastName: String
    var email: String
    var profileImage: String?
    
    var fullName: String {
        "\(name) \(lastName)"
    }
}

extension User {
    static let MockUser = User(name: "Bruce", lastName: "Wayne", email: "zalupa@gmail.com", profileImage: "mockProfile")
}
