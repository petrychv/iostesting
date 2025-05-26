import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showToast = false
    
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
        
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(40)
                
                CustomInputField(text: $viewModel.email, placeholder: "Введите почту", role: .email)
                
                CustomInputField(text: $viewModel.password, placeholder: "Введите пароль", isSecure: true, role: .password)
                
                Button {
                    Task {
                        try await viewModel.login()
                    }
                } label: {
                    Text("Войти")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))

                Button {
                    // TODO: Реализовать сброс старого пароля и создание нового (пока нет такого на api)
                } label: {
                    Text("Забыли пароль?")
                        .font(.footnote)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
                
                Divider()
                
                HStack(spacing: 3) {
                    Text("Еще не имеете аккаунт?")
                    
                    NavigationLink {
                        RegistrationView()
                    } label: {
                        Text("Зарегистрироваться")
                            .fontWeight(.bold)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.blue)
                .padding(.vertical)
            }
            .padding(.horizontal)
            .showToast(showToast: $showToast, content: toast)
        }
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
    LoginView()
}
