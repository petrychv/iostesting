//
//  Enums.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import Foundation

enum TabNavigation: Int, CaseIterable, FloatingTabProtocol {
    case contacts = 0
    case chats = 1
    case settings = 2
    
    var symbolImage: String {
        switch self {
        case .chats:
            return "bubble"
        case .contacts:
            return "person.circle"
        case .settings:
            return "gearshape"
        }
    }
    
    var tabName: String {
        switch self {
        case .chats:
            return "Чаты"
        case .contacts:
            return "Контакты"
        case .settings:
            return "Настройки"
        }
    }
}

enum APIType {
    case register(request: RegistrationRequest)
    case login(request: LoginRequest)
    
    var path: String {
        switch self {
        case .register: return "/auth/register"
        case .login: return "/auth/login"
        }
    }
    
    var url: URL? {
        return URL(string: Constants.baseURL + path)
    }
    
    var method: String {
        switch self {
        case .register, .login: return "POST"
        }
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var body: Data? {
        switch self {
        case .register(let request):
            return try? JSONEncoder().encode(request)
        case .login(let request):
            return try? JSONEncoder().encode(request)
        }
    }
    
    var request: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}

enum APIError: Error {
    case invalidRequest
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
}

//enum AuthServiceError: Error {
//    case invalidResponse
//    case userAlreadyExists
//    case invalidCredentials
//    case emailNotConfirmed
//    case invalidRefreshToken
//    case invalidVerificationCode
//    case unexpectedStatusCode(Int)
//    case missingToken
//    case networkError(Error)
//}
