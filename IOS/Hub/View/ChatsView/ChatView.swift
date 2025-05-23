//
//  ChatView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//


import SwiftUI

struct ChatView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var messageText = ""
    @State private var showSendButton = false
    let user: User
    let messages: [Message]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ProfileImageView(user: user, size: .xLarge)
                    
                    Text(user.fullName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    LazyVStack {
                                ForEach(messages) { message in
                                    ChatMessageCell(
                                        isFromCurrentUser: message.isFromCurrentUser,
                                        text: message.messageText,
                                        user: user,
                                        fontSize: CGFloat(themeManager.fontSize) // передаємо розмір шрифту сюди
                                    )
                                }
                            }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80) // простір для поля вводу
            }
            .safeAreaInset(edge: .bottom) {
                messageInputView
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Назад")
                        }
                    }
                }
            }
            .background(
                Group {
                    if themeManager.selectedWallpaper == "default" {
                        Color.white
                            .ignoresSafeArea()
                    } else {
                        Image(themeManager.selectedWallpaper)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                }
            )
        }
    }
    
    var messageInputView: some View {
        HStack(spacing: 3) {
            Button {
                // логіка прикріплення файлу
            } label: {
                Label("Прикрепить", systemImage: "paperclip")
                    .labelStyle(.iconOnly)
                    .font(.title2)
                    .frame(width: 35)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            
            TextField("Сообщение", text: $messageText, axis: .vertical)
                .font(.system(size: CGFloat(themeManager.fontSize)))
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onChange(of: messageText) { _, newValue in
                    showSendButton = !newValue.isEmpty
                }
            
            if showSendButton {
                Button {
                    // відправка повідомлення
                } label: {
                    Label("Отправить сообщение", systemImage: "arrow.up.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .frame(width: 35)
                }
            } else {
                Button {
                    // голосове повідомлення
                } label: {
                    Label("Голосовое сообщение", systemImage: "microphone")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .frame(width: 35)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.ultraThickMaterial)
        .animation(.easeInOut, value: showSendButton)
    }
}

#Preview {
    ChatView(
        user: User.MockUser,
        messages: [
            Message(messageText: "Hi!", isFromCurrentUser: true),
            Message(messageText: "Hi! How are you?", isFromCurrentUser: false)
        ]
    )
    .environmentObject(ThemeManager())
}
