//
//  ChatMessageCell.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

struct ChatMessageCell: View {
    let isFromCurrentUser: Bool
    let text: String
    let user: User
    let fontSize: CGFloat  // новий параметр

    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()

                Text(text)
                    .font(.system(size: fontSize))
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundStyle(.primary)
                    .clipShape(ChatBubbleShape(isForCurrentUser: true))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    ProfileImageView(user: user, size: .xxSmall)

                    Text(text)
                        .font(.system(size: fontSize))
                        .padding(12)
                        .background(Color(.systemGray4))
                        .foregroundStyle(.primary)
                        .clipShape(ChatBubbleShape(isForCurrentUser: false))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.7, alignment: .leading)

                    Spacer()
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    VStack {
        ChatMessageCell(isFromCurrentUser: true,
                        text: "Test Message veeery long and vory long ggfh jfdsjfh ihsdf isdhfi dhfguhi idhfgihdi",
                        user: User.MockUser,
                        fontSize: 18)
        
        ChatMessageCell(isFromCurrentUser: false,
                        text: "Test Message 3-2-1-GO!",
                        user: User.MockUser,
                        fontSize: 18)
    }
}
