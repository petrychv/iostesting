//
//  DesignSettingsView.swift
//  Hub
//
//  Created by John Robert Prince on 06.05.2025.
//

import SwiftUI
import PhotosUI

struct DesignSettingsView: View {
    @Binding var hideTabBar: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showWallpaperScreen = false

    var body: some View {
        Form {
            Section(header: Text("Превью оформления")) {
                ChatWallpaperPreview()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.vertical, 8)
            }
            
            Section {
                Button("Изменить обои") {
                    showWallpaperScreen = true
                }
            }

            Section(header: Text("Размер шрифта")) {
                Slider(value: $themeManager.fontSize, in: 12...30, step: 1)
                Text("Текущий размер: \(Int(themeManager.fontSize))")
            }

            Section(header: Text("Настройки обоев")) {
                VStack(alignment: .leading) {
                    Text("Размытие: \(String(format: "%.1f", themeManager.wallpaperBlur))")
                    Slider(value: $themeManager.wallpaperBlur, in: 0...10)
                }

                VStack(alignment: .leading) {
                    Text("Затемнение: \(String(format: "%.2f", themeManager.wallpaperDarken))")
                    Slider(value: $themeManager.wallpaperDarken, in: 0...1)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Оформление")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .hideFloatingTabBar(hideTabBar)
        .sheet(isPresented: $showWallpaperScreen) {
            WallpaperSelectionView()
                .environmentObject(themeManager)
        }
    }
    
    private struct ChatWallpaperPreview: View {
        @EnvironmentObject var themeManager: ThemeManager
        @Environment(\.colorScheme) var colorScheme

        var body: some View {
            ZStack {
                let wallpaperName = themeManager.selectedWallpaper == "default"
                    ? (colorScheme == .dark ? "defaultDark" : "default")
                    : themeManager.selectedWallpaper

                if UIImage(named: wallpaperName) != nil {
                    Image(wallpaperName)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: themeManager.wallpaperBlur)
                        .overlay(Color.black.opacity(themeManager.wallpaperDarken))
                        .ignoresSafeArea()
                } else if wallpaperName.starts(with: "user_") {
                    let index = Int(wallpaperName.replacingOccurrences(of: "user_", with: "")) ?? 0
                    if themeManager.userWallpapers.indices.contains(index) {
                        Image(uiImage: themeManager.userWallpapers[index])
                            .resizable()
                            .scaledToFill()
                            .blur(radius: themeManager.wallpaperBlur)
                            .overlay(Color.black.opacity(themeManager.wallpaperDarken))
                            .ignoresSafeArea()
                    } else {
                        Color.gray
                    }
                } else {
                    Color.gray
                }
            }
        }
    }

    private struct WallpaperSelectionView: View {
        @EnvironmentObject var themeManager: ThemeManager
        @Environment(\.dismiss) var dismiss
        @State private var showPhotoPicker = false
        @State private var selectedItem: PhotosPickerItem? = nil

        let wallpapers = ["default", "mountains", "beach", "city", "abstraction"]
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]

        enum WallpaperItem: Identifiable {
            case system(name: String)
            case user(index: Int, image: UIImage)

            var id: String {
                switch self {
                case .system(let name): return name
                case .user(let index, _): return "user_\(index)"
                }
            }
        }

        var allWallpapers: [WallpaperItem] {
            var items = wallpapers.filter { $0 != "default" }.map { WallpaperItem.system(name: $0) }
            for (index, image) in themeManager.userWallpapers.enumerated() {
                items.append(.user(index: index, image: image))
            }
            return items
        }

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Button(action: {
                            themeManager.selectedWallpaper = "default"
                        }) {
                            HStack {
                                Image(systemName: themeManager.selectedWallpaper == "default" ? "checkmark.circle.fill" : "circle")
                                Text("Системные")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }

                        let columns = [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ]

                        let imageSize = (UIScreen.main.bounds.width - 48) / 2 // 16 + 16 + 16 між трьома зонами = 48

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(allWallpapers) { item in
                                ZStack(alignment: .topTrailing) {
                                    Group {
                                        switch item {
                                        case .system(let name):
                                            Image(name)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)

                                        case .user(_, let image):
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                    .frame(width: imageSize, height: imageSize)
                                    .clipped()
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(themeManager.selectedWallpaper == item.id ? Color.accentColor : Color.clear, lineWidth: 3)
                                    )
                                    .contentShape(Rectangle()) // для кращої зони натиску
                                    .onTapGesture {
                                        themeManager.selectedWallpaper = item.id
                                    }

                                    if item.id == themeManager.selectedWallpaper {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.accentColor)
                                            .padding(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Добавить из галереи")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images)
                        .onChange(of: selectedItem) { newItem in
                            guard let item = newItem else { return }
                            item.loadTransferable(type: Data.self) { result in
                                switch result {
                                case .success(let data):
                                    if let data, let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            themeManager.userWallpapers.append(image)
                                        }
                                    }
                                case .failure(let error):
                                    print("Ошибка загрузки фото: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("Выбор обоев")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Готово") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var hideBarModel = FloatingTabViewModel()
    @StateObject var themeManager = ThemeManager()

    DesignSettingsView(hideTabBar: .constant(false))
        .environmentObject(hideBarModel)
        .environmentObject(themeManager)
}
