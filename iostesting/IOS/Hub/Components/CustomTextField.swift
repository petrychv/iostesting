import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    let role: InputFieldRole
    
    init(text: Binding<String>, placeholder: String, isSecure: Bool = false, role: InputFieldRole = .none) {
        _text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.role = role
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    TextField(placeholder, text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(role == .email ? .never : .words)
                        .keyboardType(role == .email ? .emailAddress : .default)
                }
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .font(.subheadline)
            .padding(12)
            .animation(.easeInOut, value: text)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            }
            
            Text(text.count < 5 && text.count > 0 ? role.alertDescription : "")
                .font(.caption2)
                .foregroundStyle(.red)
        }
    }
}

enum InputFieldRole {
    case password, email, none
    
    var alertDescription: String {
        switch self {
        case .password:
            return "Пароль не может содержать менее 5 символов"
        default:
            return ""
        }
    }
    
    
}

#Preview {
    @Previewable @State var textTF = ""
    @Previewable @State var textSF = ""
    
    VStack {
        CustomInputField(text: $textTF, placeholder: "Почта", isSecure: false, role: .email)
        CustomInputField(text: $textSF, placeholder: "Пароль", isSecure: true, role: .password)
    }
    .padding()
}
