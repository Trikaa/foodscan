import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}
