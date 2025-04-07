import SwiftUI

struct ProfileView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @AppStorage("email") private var email = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Hello, User!")
                    .font(.title)
                    .foregroundColor(.gray)
                
                Text(email)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        VStack {
                            Text("thank_you")
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text("thank_you_description")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    )
                    .padding(.vertical)
                
                // Переключатель языка
                VStack(alignment: .leading, spacing: 8) {
                    Text("select_language")
                        .font(.headline)
                    Picker("Language", selection: $languageManager.currentLanguage) {
                        Text("English").tag("en")
                        Text("Українська").tag("uk")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                List {
                    Label("edit_profile", systemImage: "person.crop.circle")
                    Label("eating_preferences", systemImage: "fork.knife")
                    Label("about_us", systemImage: "info.circle")
                    Label("support_center", systemImage: "lifepreserver")
                    Label("contact_us", systemImage: "envelope")
                    
                    Button(action: {
                        logout()
                    }) {
                        Label("log_out", systemImage: "arrow.backward.square")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .padding()
            .navigationTitle("profile")
        }
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
}
