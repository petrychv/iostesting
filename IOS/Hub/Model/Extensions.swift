//
//  Extensions.swift
//  Hub
//
//  Created by John Robert Prince on 29.04.2025.
//

import SwiftUI

extension Color {
    // Создает цвет из HEX-строки
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        switch hex.count {
        case 8: // #AARRGGBB (с альфа-каналом)
            alpha = Double((int >> 24) & 0xFF) / 255.0
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
        case 6: // #RRGGBB (без альфа-канала)
            alpha = 1.0
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
        default:
            alpha = 1.0
            red = 1.0
            green = 1.0
            blue = 1.0
        }
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    // Преобразует цвет в HEX-строку
    func toHex(includeAlpha: Bool = true) -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if includeAlpha {
            let argb: Int = (Int)(alpha * 255) << 24 | (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255)
            return String(format: "#%08x", argb)
        } else {
            let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255)
            return String(format: "#%06x", rgb)
        }
    }
}
