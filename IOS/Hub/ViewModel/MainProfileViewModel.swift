//
//  MainProfileViewModel.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import PhotosUI
import SwiftUI

final class MainProfileViewModel: ObservableObject {
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    
    @Published var profilePhoto: Image?
    
    func loadImage() async throws {
        guard let photo = selectedPhoto else { return }
        guard let imageData = try await photo.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profilePhoto = Image(uiImage: uiImage)
    }
}
