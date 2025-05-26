//
//  TabBarSettingsView.swift
//  Hub
//
//  Created by John Robert Prince on 06.05.2025.
//

import SwiftUI

struct TabBarSettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Вид TabBar") {
                Toggle("Прозрачность TabBar", isOn: $viewModel.isTranslucent)
                Toggle("TabBar с текстом", isOn: $viewModel.isWithText)
                Toggle("Классический вид", isOn: $viewModel.isClassic)
            }
            
            
            if !viewModel.isClassic {
                Section("Положение TabBar") {
                    SliderCell(value: $viewModel.insetAmount, range: 0...20, description: "Внутренние отступы")
                    SliderCell(value: $viewModel.hPadding, range: 0...50, description: "Боковые отступы")
                    SliderCell(value: $viewModel.bPadding, range: 0...30, description: "Нижний отступ")
                }
            }

            Section("Цвет TabBar") {
                ColorPicker("Цвет активной вкладки", selection: Binding(
                    get: { Color(hex: viewModel.activeTint) },
                    set: { newColor in
                        viewModel.activeTint = newColor.toHex() ?? "#ffffffff"
                    }
                ))
                
                if !viewModel.isClassic {
                    ColorPicker("Фон активной вкладки", selection: Binding(
                        get: { Color(hex: viewModel.activeBackgroundTint) },
                        set: { newColor in
                            viewModel.activeBackgroundTint = newColor.toHex() ?? "#ff007aff"
                        }
                    ))
                }
                
                ColorPicker("Цвет неактивной вкладки", selection: Binding(
                    get: { Color(hex: viewModel.inactiveTint) },
                    set: { newColor in
                        viewModel.inactiveTint = newColor.toHex() ?? "#ff8e8e93"
                    }
                ))
                
                ColorPicker("Общий цвет фона", selection: Binding(
                    get: { Color(hex: viewModel.backgroundColor) },
                    set: { newColor in
                        viewModel.backgroundColor = newColor.toHex() ?? "#668e8e93"
                    }
                ))
            }
            
            Button("По умолчанию") {
                withAnimation {
                    viewModel.isTranslucent = true
                    viewModel.isWithText = true
                    viewModel.insetAmount = 6
                    viewModel.hPadding = 15
                    viewModel.bPadding = 5
                    viewModel.activeTint = "#ffffffff"
                    viewModel.activeBackgroundTint = "#ff007aff"
                    viewModel.inactiveTint = "#ff8e8e93"
                    viewModel.backgroundColor = "#668e8e93"
                    viewModel.isClassic = false
                }
            }
        }
        .safeAreaPadding(.bottom, 60)
        .navigationTitle("TabBar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SliderCell: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(description): \(value.formatted())")
            
            Slider(value: $value, in: range, step: 1) {
                Text("Отступы")
            } minimumValueLabel: {
                Text("\(range.lowerBound.formatted())")
            } maximumValueLabel: {
                Text("\(range.upperBound.formatted())")
            }
        }
    }
}

#Preview {
    NavigationStack {
        TabBarSettingsView()
            .environmentObject(SettingsViewModel())
    }
}
