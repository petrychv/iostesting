//
//  SettingsView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = ThemeMode.system.rawValue
    
    @Published var selectedWallpaper: String = "default"  
    @Published var fontSize: Double = 16
    @Published var wallpaperBlur: Double = 0.0
    @Published var wallpaperDarken: Double = 0.0
    @Published var userWallpapers: [UIImage] = []
    
    var selectedTheme: ThemeMode {
        get {
            ThemeMode(rawValue: selectedThemeRaw) ?? .system
        }
        set {
            selectedThemeRaw = newValue.rawValue
        }
    }
    
    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // Использовать системные настройки
        }
    }
}

enum ThemeMode: String, CaseIterable {
    case light = "Светлая"
    case dark = "Темная"
    case system = "Системная"
}

struct SettingsTabItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText: String = ""
    @State private var hideTabBar: Bool = false
    @Binding var user: User
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        MainProfileView(user: $user)
                    } label: {
                        HStack(spacing: 10) {
                            ProfileImageView(user: user, size: .xLarge)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Text("CEO Apple")
                                    .font(.subheadline)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        
                    } label: {
                        Label("Уведомления", systemImage: "bell.badge.circle.fill")
                            .accentColor(.red)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Label("Конфиденциальность", systemImage: "lock.circle.fill")
                            .accentColor(.gray)
                    }
                }
                
                Section(header: Text("Оформление")) {
                    Picker(selection: $themeManager.selectedTheme) {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    } label: {
                        Label("Тема", systemImage: "circle.lefthalf.filled")
                            .accentColor(.primary)
                    }
                    
                    NavigationLink {
                        TabBarSettingsView()
                    } label: {
                        Label("Вид TabView", systemImage: "pencil.tip.crop.circle.fill")
                            .accentColor(.green)
                    }

                    NavigationLink {
                        DesignSettingsView(hideTabBar: $hideTabBar)  
                    } label: {
                        Label("Обои для чатов", systemImage: "photo.circle.fill")
                            .accentColor(.indigo)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Label("Язык", systemImage: "globe")
                            .accentColor(.purple)
                    }
                }
                
                Section {
                    NavigationLink {
                        
                    } label: {
                        Label("Помощь", systemImage: "questionmark.circle.fill")
                            .accentColor(.yellow)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Label("Сообщить о проблеме", systemImage: "exclamationmark.circle.fill")
                            .accentColor(.orange)
                    }
                    
                    NavigationLink {
                        Link("Перейти на сайт проекта", destination: URL(string: "https://hub-net.org")!)
                    } label: {
                        Label("О проекте Hub", systemImage: "info.circle.fill")
                            .accentColor(.blue)
                    }
                }
                
                Section {
                    Button("Выйти", role: .destructive) {
                        
                    }
                    
                    Button("Удалить аккаунт", role: .destructive) {
                        
                    }
                }
            }
            .navigationBarTitle("Настройки")
            .safeAreaPadding(.bottom, 70)
        }
        .searchable(text: $searchText, prompt: "Поиск")
        .hideFloatingTabBar(hideTabBar)
    }
}

#Preview {
    @Previewable @StateObject var themeManager = ThemeManager()
    @Previewable @StateObject var hideBarModel = FloatingTabViewModel()
    
    SettingsTabItem(user: .constant(User.MockUser))
        .environmentObject(themeManager)
        .environmentObject(hideBarModel)
        .environmentObject(SettingsViewModel())
        .preferredColorScheme(themeManager.colorScheme)
}
