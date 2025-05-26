//
//  Toast.swift
//  Hub
//
//  Created by John Robert Prince on 05.05.2025.
//

import SwiftUI

struct TestToastView: View {
    @State private var showTopToast = false
    @State private var showBottomToast = false
    
    var toast: some View {
        ToastConfig(
            showToast: $showBottomToast,
            toastData: ToastConfig.ToastData(
                title: "Успех!",
                image: "checkmark.shield.fill",
                imageColor: Color(.systemGreen),
                message: "Вы успешно вошли в систему",
                backgroundColor: .green),
            position: .bottom)
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Show Top Toast!") {
                withAnimation {
                    showTopToast = true
                }
            }
            
            Button("Show Bottom Toast!") {
                withAnimation {
                    showBottomToast = true
                }
            }
        }
        .showToast(showToast: $showTopToast, content: ToastConfig(showToast: $showTopToast, toastData: ToastConfig.ToastData()))
        .showToast(showToast: $showBottomToast, content: toast)
    }
}

struct ToastConfig: View {
    enum ToastPosition {
        case top
        case bottom
    }
    
    struct ToastData {
        var title: String = "Упс, ошибка!"
        var image: String = "xmark.octagon"
        var imageColor: Color = .red
        var message: String = "Что-то пошло не так:("
        var backgroundColor: Color = .red
    }
    
    @Binding var showToast: Bool
    var toastData: ToastData
    var position: ToastPosition = .top
    
    var body: some View {
        VStack {
            if position == .bottom {
                Spacer()
            }
            
            ToastView(toastData: toastData)
                .background(toastData.backgroundColor.opacity(0.3))
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            
            if position == .top {
                Spacer()
            }
        }
        .padding()
        .opacity(self.showToast ? 1 : 0)
        .transition(.move(edge: position == .top ? .top : .bottom))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.showToast = false
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1.5)) {
                self.showToast = false
            }
        }
    }
}

struct ToastView: View {
    let toastData: ToastConfig.ToastData
    
    var body: some View {
        HStack {
            Image(systemName: toastData.image)
                .font(.title)
                .foregroundStyle(toastData.imageColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(toastData.title))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.7))
                Text(LocalizedStringKey(toastData.message))
                    .font(.callout)
                    .opacity(0.9)
            }
            Spacer()
        }
        .foregroundColor(Color.gray)
        .padding(10)
    }
}

struct ToastModifier<T: View>: ViewModifier {
    @Binding var showToast: Bool
    let content: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if showToast {
                    self.content
                } else {
                    EmptyView()
                }
            }
        }
    }
}

extension View {
    func showToast<T: View>(showToast: Binding<Bool>, content: T) -> some View {
        self.modifier(ToastModifier(showToast: showToast, content: content))
    }
}

#Preview {
    TestToastView()
}
