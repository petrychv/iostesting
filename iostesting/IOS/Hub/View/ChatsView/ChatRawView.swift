//
//  InboxRawView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

struct ChatRawView: View {
    let user: User
    let lastMessage: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProfileImageView(user: user, size: .medium)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            HStack {
                Text("Yesterday")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ChatRawView(user: User.MockUser, lastMessage: "Some messege here that can be more than one string bla bla bla")
        .padding()
}
