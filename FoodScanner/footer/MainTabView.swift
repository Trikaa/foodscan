import SwiftUI

struct MainTabView: View {
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("profile".localized, systemImage: "person")
                }
            
            ScanView()
                .tabItem {
                    Label("scan".localized, systemImage: "qrcode.viewfinder")
                }
            
            HistoryView()
                .tabItem {
                    Label("history".localized, systemImage: "clock.arrow.circlepath")
                }
        }
        .id(languageManager.currentLanguage) // 🔥 Обновляем при смене языка
    }
}
