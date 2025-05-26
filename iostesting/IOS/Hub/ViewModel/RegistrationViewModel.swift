import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: LoginOrRegistrationError = .none
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private var canRegister: Bool {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
        
        guard password == confirmPassword else {
            errorMessage = .repeatPasswordError
            return false
        }
        
        errorMessage = .none
        return true
    }
    
    // Документация по api в части регистрации устарела, надо править
    func createUser() async throws {
        guard canRegister else { return }
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let publicId = String(uuid.prefix(30))
        
        let registrationData = RegistrationRequest(
            publicId: publicId,
            firstName: username,
            lastName: lastName,
            email: email,
            password: password
        )
        
        try await AuthService.shared.createUser(request: registrationData)
    }
}

struct RegistrationRequest: Codable {
    let publicId: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct RegistrationResponse: Codable {
    let message: String
}
