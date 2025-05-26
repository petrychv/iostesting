//
//  Constants.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import Foundation

class Constants {
    static let baseURL = "https://server.hub-net.org/dev/api"
    
    static let tonyStark = User(name: "Tony", lastName: "Stark", email: "TonyStark@mail.ru", profileImage: "tonyStark")
    static let batman = User(name: "Bat", lastName: "Man", email: "Batman@mail.ru", profileImage: "batman")
    static let margoRobby = User(name: "Margo", lastName: "Robby", email: "MargoRobby@mail.ru", profileImage: "margoRobby")
    static let jasonStatham = User(name: "Jason", lastName: "Statham", email: "JasonStatham@mail.ru", profileImage: "jasonStatham")
    static let arnold = User(name: "Arnold", lastName: "Shwarzenegger", email: "ArnoldShwarzenegger@mail.ru", profileImage: "arnold")
    
    static let allUsers: [User] = [tonyStark, batman, margoRobby, jasonStatham, arnold]
}
