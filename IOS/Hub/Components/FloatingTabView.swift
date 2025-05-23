//
//  FloatingTabView.swift
//  Hub
//
//  Created by John Robert Prince on 01.05.2025.
//

import SwiftUI

protocol FloatingTabProtocol {
    var symbolImage: String { get }
    var tabName: String { get }
}

final class FloatingTabViewModel: ObservableObject {
    @Published var hideTabBar: Bool = false
}

struct HideFloatingTabBarModifier: ViewModifier {
    var status: Bool
    @EnvironmentObject private var viewModel: FloatingTabViewModel
    
    func body(content: Content) -> some View {
        content
            .onChange(of: status, initial: true) { _, newValue in
                viewModel.hideTabBar = newValue
            }
    }
}

extension View {
    func hideFloatingTabBar(_ status: Bool) -> some View {
        self
            .modifier(HideFloatingTabBarModifier(status: status))
    }
}

struct FloatingTabView<Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    var config: FloatingTabConfig
    @Binding var selection: Value
    @Binding var scrollOnTop: [Bool]
    var content: (Value, CGFloat) -> Content // get height of tabbar for bottom padding
    
    init(config: FloatingTabConfig = .init(), selection: Binding<Value>, scrollOnTop: Binding<[Bool]>, @ViewBuilder content: @escaping (Value, CGFloat) -> Content) {
        self.config = config
        self._selection = selection
        self._scrollOnTop = scrollOnTop
        self.content = content
    }
    
    @State private var tabBarSize: CGSize = .zero
    @StateObject private var viewModel: FloatingTabViewModel = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        Tab.init(value: tab) {
                            content(tab, tabBarSize.height)
                                .toolbarVisibility(.hidden, for: .tabBar) // hiding native TabBar
                        }
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        content(tab, tabBarSize.height)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar) // hiding native TabBar
                    }
                }
            }
            
            if !config.isClassic {
                FloatingTabBar(config: config, activeTab: $selection, scrollOnTop: $scrollOnTop)
                    .padding(.horizontal, config.hPadding)
                    .padding(.bottom, config.bPadding)
                //                .onGeometryChange(for: CGSize.self) {
                //                    $0.size
                //                } action: { newValue in
                //                    tabBarSize = newValue
                //                }
                    .offset(y: viewModel.hideTabBar ? (tabBarSize.height + 100) : 0)
                    .animation(config.tabAnimation, value: viewModel.hideTabBar)
            }
        }
        .environmentObject(viewModel)
        .safeAreaInset(edge: .bottom) {
            if config.isClassic {
                ClassicTabBar(config: config,
                              activeTab: $selection,
                              scrollOnTop: $scrollOnTop
                )
                .offset(y: viewModel.hideTabBar ? (tabBarSize.height + 100) : 0)
            }
        }
    }
}

struct FloatingTabConfig {
    var activeTint: Color = .white
    var activeBackgroundTint: Color = .blue
    var inactiveTint: Color = .gray
    var tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0)
    var backgroundColor: Color = .gray.opacity(0.1)
    var insetAmount: CGFloat = 6
    var isTranslucent: Bool = true
    var hPadding: CGFloat = 10
    var bPadding: CGFloat = 0
    var isWithText: Bool = true
    var isClassic: Bool = false
}

fileprivate struct FloatingTabBar<Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    var config: FloatingTabConfig
    @Binding var activeTab: Value
    @Binding var scrollOnTop: [Bool]
    @Namespace private var animation // for tab sliding effect
    @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: Value.allCases.count)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Value.allCases, id: \.hashValue) { tab in
                let isActive = activeTab == tab
                let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0
                
                VStack(spacing: 0) {
                    Image(systemName: tab.symbolImage)
                        .font(.title)
                        .symbolEffect(.bounce.byLayer.down, value: toggleSymbolEffect[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                    
                    if config.isWithText {
                        Text(tab.tabName)
                            .font(.footnote)
                    }
                }
                .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
                .background {
                    if isActive {
                        Capsule(style: .continuous)
                            .fill(config.activeBackgroundTint.gradient)
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
                .padding(.vertical, config.insetAmount)
            }
        }
        .padding(.horizontal, config.insetAmount)
        .frame(height: 55)
        .background {
            ZStack {
                if config.isTranslucent {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.background)
                }
                
                Rectangle()
                    .fill(config.backgroundColor)
            }
        }
        .clipShape(.capsule(style: .continuous))
        .animation(config.tabAnimation, value: activeTab)
    }
}

fileprivate struct ClassicTabBar<Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    var config: FloatingTabConfig
    @Binding var activeTab: Value
    @Binding var scrollOnTop: [Bool]
    @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: Value.allCases.count)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Value.allCases, id: \.hashValue) { tab in
                let isActive = activeTab == tab
                let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0
                
                VStack(spacing: 0) {
                    Image(systemName: tab.symbolImage)
                        .font(.title)
                        .symbolEffect(.bounce.down, value: toggleSymbolEffect[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                    
                    if config.isWithText {
                        Text(tab.tabName)
                            .font(.footnote)
                    }
                }
                .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
                .onTapGesture {
                    if activeTab == tab {
                        scrollOnTop[index].toggle()
                    } else {
                        activeTab = tab
                        toggleSymbolEffect[index].toggle()
                    }
                }
            }
        }
        .frame(height: 55)
        .background {
            Color(config.backgroundColor)
                .overlay(config.isTranslucent ? .ultraThinMaterial : .regularMaterial)
                .ignoresSafeArea()
        }
        .animation(config.tabAnimation, value: activeTab)
    }
}

struct ClassicTabView<Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    var config: FloatingTabConfig
    @Binding var selection: Value
    @Binding var scrollOnTop: [Bool]
    var content: (Value, CGFloat) -> Content // get height of tabbar for bottom padding
    
    init(config: FloatingTabConfig = .init(), selection: Binding<Value>, scrollOnTop: Binding<[Bool]>, @ViewBuilder content: @escaping (Value, CGFloat) -> Content) {
        self.config = config
        self._selection = selection
        self._scrollOnTop = scrollOnTop
        self.content = content
    }
    
    @State private var tabBarSize: CGSize = .zero
    @StateObject private var viewModel: FloatingTabViewModel = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        Tab.init(value: tab) {
                            content(tab, tabBarSize.height)
                                .toolbarVisibility(.hidden, for: .tabBar) // hiding native TabBar
                        }
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        content(tab, tabBarSize.height)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar) // hiding native TabBar
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .safeAreaInset(edge: .bottom) {
            ClassicTabBar(config: .init(
                activeTint: .blue,
                activeBackgroundTint: .clear,
                insetAmount: 0,
                isTranslucent: true,
                hPadding: 0,
                bPadding: 0),
                          activeTab: $selection,
                          scrollOnTop: $scrollOnTop
            )
        }
    }
}

struct ClassicView: View {
    @State private var currentUser: User = AuthService.shared.uploadUserData()
    @State private var selectedTab: TabNavigation = .chats
    @State private var scrollOnTop: [Bool] = Array(repeating: false, count: TabNavigation.allCases.count)
    
    var body: some View {
        ClassicTabView(selection: $selectedTab, scrollOnTop: $scrollOnTop) { tab, _ in
            switch tab {
            case .contacts:
                Text("Contacts")
            case .chats:
                Text("Chats")
            case .settings:
                SettingsTabItem(user: $currentUser)
            }
        }

    }
}

#Preview {
    ClassicView()
}
