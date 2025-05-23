//
//  SettingsViewModel.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("activeTint") var activeTint: String = "#ffffffff"
    @AppStorage("activeBackgroundTint") var activeBackgroundTint: String = "#ff007aff"
    @AppStorage("inactiveTint") var inactiveTint: String = "#ff8e8e93"
    @AppStorage("backgroundColor") var backgroundColor: String = "#668e8e93"
    @AppStorage("insetAmount") var insetAmount: Double = 6
    @AppStorage("isWithText") var isWithText: Bool = true
    @AppStorage("isTranslucent") var isTranslucent: Bool = true
    @AppStorage("isClassic") var isClassic: Bool = false
    @AppStorage("horizontalPadding") var hPadding: Double = 15
    @AppStorage("bottomPadding") var bPadding: Double = 5
}
