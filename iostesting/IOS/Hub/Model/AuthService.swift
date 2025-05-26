//
//  AuthService.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import Foundation

class AuthService {
    @Published var userSession: Bool = false
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    private init() {}
    
    // Вход пользователя
    func login(request: LoginRequest) async throws {
        let url = APIType.login(request: request)
        
        // Проверяем, что запрос валиден
        guard let urlRequest = url.request else {
            print("Error 1")
            throw APIError.invalidRequest
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Проверяем тип ответа
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error 2")
                throw APIError.invalidResponse
            }
            
            // Проверяем статус-код
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error 3, \(httpResponse.statusCode)")
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // Декодируем данные
            let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            userSession = true
            print("Success!!! \(decodedResponse.message)")
        } catch let decodingError as DecodingError {
            // Обрабатываем ошибку декодирования
            print(decodingError.localizedDescription)
            throw APIError.decodingError(decodingError)
        } catch {
            // Обрабатываем другие ошибки (например, сетевые)
            print(error.localizedDescription)
            throw APIError.networkError(error)
        }
    }
    
    // Регистрация пользователя
    func createUser(request: RegistrationRequest) async throws {
        let url = APIType.register(request: request)
        
        // Проверяем, что запрос валиден
        guard let urlRequest = url.request else {
            throw APIError.invalidRequest
        }
        
        do {
            // Выполняем сетевой запрос с помощью URLSession и async/await
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Проверяем тип ответа
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Проверяем статус-код
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error 3, \(httpResponse.statusCode)")
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // Декодируем данные
             let decodedResponse = try JSONDecoder().decode(RegistrationResponse.self, from: data)
            userSession = true
            print("Success!!! \(decodedResponse.message)")
        } catch let decodingError as DecodingError {
            // Обрабатываем ошибку декодирования
            print(decodingError.localizedDescription)
            throw APIError.decodingError(decodingError)
        } catch {
            // Обрабатываем другие ошибки (например, сетевые)
            print(error.localizedDescription)
            throw APIError.networkError(error)
        }
    }
    
    func signOut() {
        userSession = false
    }
    
    func uploadUserData() -> User {
        return User.MockUser
    }
}
