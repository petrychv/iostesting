import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var showToast = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let toast = ToastConfig(
            showToast: $showToast,
            toastData: ToastConfig.ToastData(
                title: "Неверные данные",
                image: "xmark.octagon",
                imageColor: .red,
                message: viewModel.errorMessage.description,
                backgroundColor: Color(.systemRed)),
            position: .top)
        
        VStack(spacing: 0) {
            Spacer()
 
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(30)
            
            VStack(spacing: 5) {
                CustomInputField(text: $viewModel.username, placeholder: "Имя")
                CustomInputField(text: $viewModel.lastName, placeholder: "Фамилия")
                CustomInputField(text: $viewModel.email, placeholder: "Email", role: .email)
                CustomInputField(text: $viewModel.password, placeholder: "Пароль", isSecure: true, role: .password)
                CustomInputField(text: $viewModel.confirmPassword, placeholder: "Повторите пароль", isSecure: true)
            }
            
            Button {
                Task {
                    try await viewModel.createUser()
                }
            } label: {
                Text("Зарегистрироваться")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
            
            Spacer()
            
            Divider()
            
            HStack(spacing: 3) {
                Text("Уже есть аккаунт?")
                
                Button {
                    dismiss()
                } label: {
                    Text("Войти")
                        .fontWeight(.bold)
                }
            }
            .font(.footnote)
            .foregroundStyle(.blue)
            .padding(.vertical)
        }
        .padding(.horizontal)
        .showToast(showToast: $showToast, content: toast)
        .navigationBarBackButtonHidden()
        .onReceive(viewModel.$errorMessage) { newError in
            if newError != .none {
                withAnimation {
                    showToast = true
                }
            } else {
                withAnimation {
                    showToast = false
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}

