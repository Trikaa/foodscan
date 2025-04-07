import SwiftUI

struct AuthGateView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}
