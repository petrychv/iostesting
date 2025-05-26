//
//  NewMessageView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

class NewMessageViewModel: ObservableObject {
    let users: [User] = Constants.allUsers
}

struct ContactsTabItem: View {
    @StateObject private var viewModel = NewMessageViewModel()
    @State private var searchText = ""
    @Binding var selectedUser: User?
    @Binding var scrollOnTop: Bool
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.title)
                            Text("Пригласить")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundStyle(.blue)
                    }
                    .id("TOP")
                    
                    ForEach(searchResult) { user in
                        HStack {
                            ProfileImageView(user: user, size: .small)
                            
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .onTapGesture {
                            selectedUser = user
                        }
                    }
                }
                .safeAreaPadding(.bottom, 70)
                .listStyle(.plain)
                .navigationTitle("Контакты")
                .onChange(of: scrollOnTop == true) {
                    withAnimation {
                        proxy.scrollTo("TOP", anchor: .top)
                    }
                    scrollOnTop = false
                }
            }
        }
        .searchable(text: $searchText, prompt: "Поиск")
    }
    
    var searchResult: [User] {
        if searchText.isEmpty {
            return viewModel.users.sorted { $0.fullName < $1.fullName }
        } else {
            return viewModel.users.filter { $0.fullName.contains(searchText) }
        }
    }
}

#Preview {
    ContactsTabItem(selectedUser: .constant(User.MockUser), scrollOnTop: .constant(false))
}
