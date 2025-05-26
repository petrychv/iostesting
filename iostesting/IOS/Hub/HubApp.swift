import SwiftUI

@main
struct HubApp: App {
    @StateObject private var themeManager = ThemeManager()
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
