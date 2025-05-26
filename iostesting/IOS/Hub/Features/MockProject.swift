//
//  MockProject.swift
//  Hub
//
//  Created by John Robert Prince on 10.05.2025.
//

import SwiftUI

struct MockProject: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var selectedTab: TabNavigation = .chats
    @State private var scrollOnTop: [Bool] = Array(repeating: false, count: TabNavigation.allCases.count)
    @State private var loginDescription: String = ""
    @State private var registerDescription: String = ""
    @State private var showModal: Bool = false
    let loginRequest: LoginRequest = .init(email: "johnrobert.prince@mail.ru", password: "qwerty")
    let registerRequest: RegistrationRequest = .init(publicId: "jrprince", firstName: "JohnRobert", lastName: "Prince", email: "johnrobert.prince@mail.ru", password: "qwerty")
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .contacts:
                NavigationStack {
                    Text("Contacts")
                        .navigationTitle("Contacts")
                }
            case .chats:
                NavigationStack {
                    VStack {
                        Text("User session: \(AuthService.shared.userSession)")
                        Text("Login action: \(loginDescription)")
                        Button("Login") {
                            Task {
                                try await AuthService.shared.login(request: loginRequest)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        Text("Register action: \(registerDescription)")
                        Button("Register") {
                            Task {
                                try await AuthService.shared.createUser(request: registerRequest)
                            }
                        }
                    }
                    .navigationTitle("Chats")
                }
            case .settings:
                NavigationStack {
//                    NavigationLink {
//                        TabBarSettingsView()
//                            .environmentObject(viewModel)
//                    } label: {
//                        Label("Вид TabView", systemImage: "pencil.tip.crop.circle.fill")
//                            .accentColor(.green)
//                    }
                    Button {
                        showModal.toggle()
                    } label: {
                        Label("Вид TabView", systemImage: "pencil.tip.crop.circle.fill")
                            .accentColor(.green)
                    }
                    .fullScreenCover(isPresented: $showModal) {
                        TabBarSettingsView()
                            .environmentObject(viewModel)
                    }
                    .navigationTitle("Settings")
                }
            }
            
            CustomTabView(activeTab: $selectedTab, scrollOnTop: $scrollOnTop)
        }
    }
}

struct CustomTabView: View {
    @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: TabNavigation.allCases.count)
    @Binding var activeTab: TabNavigation
    @Binding var scrollOnTop: [Bool]
    @Namespace private var animation
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(TabNavigation.allCases, id: \.hashValue) { tab in
                    let isActive = activeTab == tab
                    let index = (TabNavigation.allCases.firstIndex(of: tab)) ?? 0
                    
                    VStack(spacing: 0) {
                        Image(systemName: tab.symbolImage)
                            .font(.title)
                            .symbolEffect(.bounce.down, value: toggleSymbolEffect[index])
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(.rect)
                        
                        //if config.isWithText {
                        Text(tab.tabName)
                            .font(.footnote)
                        //}
                    }
                    .foregroundStyle(isActive ? .white : .gray)
                    .background {
                        if isActive {
                            Capsule(style: .continuous)
                                .fill(.blue.gradient)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        if activeTab == tab {
                            scrollOnTop[index].toggle()
                        } else {
                            activeTab = tab
                            toggleSymbolEffect[index].toggle()
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            //.padding(.horizontal, 0)
            .frame(height: 55)
            .background {
                ZStack {
                    //if config.isTranslucent {
                        Rectangle()
                            .fill(.ultraThinMaterial)
//                    } else {
//                        Rectangle()
//                            .fill(.background)
//                    }
                    
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                }
            }
            .clipShape(.capsule(style: .continuous))
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: activeTab)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MockProject()
}
