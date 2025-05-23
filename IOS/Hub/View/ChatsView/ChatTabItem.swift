//
//  ChatTabItem.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import SwiftUI

struct ChatTabItem: View {
    @StateObject private var viewModel = ChatTabItemViewModel()
    @State private var selectedGroup = "Все"
    @State private var showChat = false
    @State private var showProfile = false
    @State private var globalSearch = ""
    @Binding var user: User
    @Binding var selectedUser: User?
    @Binding var scrollOnTop: Bool
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack(spacing: 15) {
                    HStack {
                        Button {
                            showProfile = true
                        } label: {
                            ProfileImageView(user: user, size: .xSmall)
                        }
                        
                        TextField("Поиск", text: $globalSearch, prompt: Text("Поиск"))
                            .padding()
                            .frame(height: 35)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(Color(.systemGray5).gradient)
                            }
                        
                        Menu {
                            Button {
                                
                            } label: {
                                Text("Создать группу")
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundStyle(.blue, Color(.systemGray5).gradient)
                        }
                    }
                    .id("TOP")
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(viewModel.groups.keys), id: \.self) { key in
                                Button {
                                    selectedGroup = key
                                } label: {
                                    Text(key)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                                        .background {
                                            Capsule()
                                                .fill(Color(.systemGray5).gradient)
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.groups[selectedGroup] ?? viewModel.allChats, id: \.self) { user in
                        Button {
                            selectedUser = user
                            showChat = true
                        } label: {
                            ChatRawView(user: user, lastMessage: viewModel.mockData[user]?.last?.messageText ?? "None")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = viewModel.allChats.firstIndex(where: { $0 == user }) {
                                    viewModel.allChats.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                
                            } label: {
                                Image(systemName: "pin.fill")
                                    .tint(.green)
                            }
                        }
                    }
                }
                .safeAreaPadding(.bottom, 70)
                .onChange(of: selectedUser) { _, newValue in
                    showChat = newValue != nil
                }
                .onChange(of: scrollOnTop == true) {
                    withAnimation {
                        proxy.scrollTo("TOP", anchor: .top)
                    }
                    scrollOnTop = false
                }
                .fullScreenCover(isPresented: $showChat) {
                    if let user = selectedUser {
                        ChatView(user: user, messages: viewModel.mockData[user] ?? [Message(messageText: "df", isFromCurrentUser: true)])
                    }
                }
                .listStyle(.plain)
                .sheet(isPresented: $showProfile) {
                    NavigationStack {
                        MainProfileView(user: $user)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button("Закрыть") {
                                        showProfile = false
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
//    private func swipeIcon(label: String, symbolName: String) -> some View {
//        let w: CGFloat = 60
//        let h = w
//        let size = CGSize(width: w, height: h)
//        let text = Text(LocalizedStringKey(label))
//        let symbol = Image(systemName: symbolName)
//        return Image(size: size, label: text) { ctx in
//            let resolvedText = ctx.resolve(text)
//            let textSize = resolvedText.measure(in: CGSize(width: w, height: h * 0.6))
//            let resolvedSymbol = ctx.resolve(symbol)
//            let symbolSize = resolvedSymbol.size
//            let heightForSymbol: CGFloat = min(h * 0.35, (h * 0.9) - textSize.height)
//            let widthForSymbol = (heightForSymbol / symbolSize.height) * symbolSize.width
//            let xSymbol = (w - widthForSymbol) / 2
//            let ySymbol = max(h * 0.05, heightForSymbol - (textSize.height * 0.6))
//            let yText = ySymbol + heightForSymbol + max(0, ((h * 0.8) - heightForSymbol - textSize.height) / 2)
//            let xText = (w - textSize.width) / 2
//            ctx.draw(
//                resolvedSymbol,
//                in: CGRect(x: xSymbol, y: ySymbol, width: widthForSymbol, height: heightForSymbol)
//            )
//            ctx.draw(
//                resolvedText,
//                in: CGRect(x: xText, y: yText, width: textSize.width, height: textSize.height)
//            )
//        }
//        .foregroundStyle(.white)
//        .font(.body)
//        .lineLimit(2)
//        .lineSpacing(-2)
//        .minimumScaleFactor(0.7)
//        .multilineTextAlignment(.center)
//    }
}

#Preview {
    ChatTabItem(user: .constant(User.MockUser), selectedUser: .constant(Constants.tonyStark), scrollOnTop: .constant(false))
}
