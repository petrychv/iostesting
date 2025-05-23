//
//  InboxView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = SettingsViewModel()
    @State private var currentUser: User = AuthService.shared.uploadUserData()
    @State private var selectedTab: TabNavigation = .chats
    @State private var selectedUser: User?
    @State private var scrollOnTop: [Bool] = Array(repeating: false, count: TabNavigation.allCases.count)
    
    var body: some View {
        FloatingTabView(
            config: FloatingTabConfig(
                activeTint: Color(hex: viewModel.activeTint),
                activeBackgroundTint: Color(hex: viewModel.activeBackgroundTint),
                inactiveTint: Color(hex: viewModel.inactiveTint),
                backgroundColor: Color(hex: viewModel.backgroundColor),
                insetAmount: viewModel.insetAmount,
                isTranslucent: viewModel.isTranslucent,
                hPadding: viewModel.hPadding,
                bPadding: viewModel.bPadding,
                isWithText: viewModel.isWithText,
                isClassic: viewModel.isClassic),
            selection: $selectedTab,
            scrollOnTop: $scrollOnTop) { tab, _ in
                switch tab {
                case .contacts:
                    ContactsTabItem(selectedUser: $selectedUser, scrollOnTop: $scrollOnTop[TabNavigation.contacts.rawValue])
                case .chats:
                    ChatTabItem(user: $currentUser, selectedUser: $selectedUser, scrollOnTop: $scrollOnTop[TabNavigation.chats.rawValue])
                case .settings:
                    SettingsTabItem(user: $currentUser)
                        .environmentObject(viewModel)
                }
            }
    }
}

#Preview {
    @Previewable @StateObject var themeManager = ThemeManager()

    MainTabView()
        .environmentObject(themeManager)
}
