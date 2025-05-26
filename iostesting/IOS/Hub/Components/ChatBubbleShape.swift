//
//  ChatBubbleShape.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

struct ChatBubbleShape: Shape {
    let isForCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    isForCurrentUser ? .bottomLeft : .bottomRight
                                ],
                                cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

#Preview {
    Group {
        ChatBubbleShape(isForCurrentUser: true)
            .fill(Color.blue)
        ChatBubbleShape(isForCurrentUser: false)
            .fill(Color(.systemGray4))
    }
    .frame(height: 50)
    .padding()
}
