//
//  ContentViewModel.swift
//  Hub
//
//  Created by John Robert Prince on 26.04.2025.
//

import Combine
import Foundation

final class ContentViewModel: ObservableObject {
    @Published var userSession = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }

    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSessionFromAuthService in
            self?.userSession = userSessionFromAuthService
        }.store(in: &cancellables)
    }
}
