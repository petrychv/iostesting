import SwiftUI

enum LoginOrRegistrationError {
    case emptyFields
    case emailError
    case passwordError
    case repeatPasswordError
    case none
    
    var description: String {
        switch self {
        case .emptyFields:
            return "Пожалуйста, заполните все поля."
        case .emailError:
            return "Введите корректный e-mail."
        case .passwordError:
            return "Пароль должен содержать минимум 5 символов."
        case .repeatPasswordError:
            return "Пароли не совпадают."
        case .none:
            return ""
        }
    }
}

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: LoginOrRegistrationError = .none
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private var canLogin: Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = .emptyFields
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = .emailError
            return false
        }
        
        guard password.count >= 4 else {
            errorMessage = .passwordError
            return false
        }
        
        errorMessage = .none
        return true
    }
    
    // Документация по api в части входа устарела, надо править
    func login() async throws {
        guard canLogin else { return }
        
        let loginData = LoginRequest(email: email, password: password)
        
        try await AuthService.shared.login(request: loginData)
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String
}
