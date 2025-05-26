//
//  DesignSettingsView.swift
//  Hub
//
//  Created by John Robert Prince on 06.05.2025.
//

import SwiftUI

struct DesignSettingsView: View {
    @Binding var hideTabBar: Bool
    @EnvironmentObject var themeManager: ThemeManager

    let wallpapers = ["default", "mountains", "beach", "city"]

    var body: some View {
        Form {
            Section(header: Text("Обои")) {
                Picker("Выберите обои", selection: $themeManager.selectedWallpaper) {
                    ForEach(wallpapers, id: \.self) { wallpaper in
                        Text(wallpaper.capitalized)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("Размер шрифта")) {
                Slider(value: $themeManager.fontSize, in: 12...30, step: 1) {
                    Text("Размер шрифта")
                }
                Text("Текущий размер: \(Int(themeManager.fontSize))")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Оформление")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
        .hideFloatingTabBar(hideTabBar)
    }
}

#Preview {
    @Previewable @StateObject var hideBarModel = FloatingTabViewModel()

    DesignSettingsView(hideTabBar: .constant(false))
        .environmentObject(hideBarModel)
        .environmentObject(ThemeManager())
}
