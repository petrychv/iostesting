//
//  ProfileImageView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import SwiftUI

struct ProfileImageView: View {
    let user: User
    let size: ProfileImageSize
    
    var body: some View {
        if let imageURL = user.profileImage {
            Image(imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: size.size, height: size.size)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.size, height: size.size)
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case maxLarge
    
    var size: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xLarge: return 80
        case .maxLarge: return 120
        }
    }
}

#Preview {
    ProfileImageView(user: User.MockUser, size: .maxLarge)
}
