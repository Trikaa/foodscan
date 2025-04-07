import SwiftUI

struct ProfileView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @AppStorage("email") private var email = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("hello_user".localized)
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
                            Text("thank_you".localized)
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text("thank_you_description".localized)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    )
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("select_language".localized)
                        .font(.headline)
                    Picker("language_picker".localized, selection: $languageManager.currentLanguage) {
                        Text("english".localized).tag("en")
                        Text("ukrainian".localized).tag("uk")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                List {
                    Label("edit_profile".localized, systemImage: "person.crop.circle")
                    Label("eating_preferences".localized, systemImage: "fork.knife")
                    Label("about_us".localized, systemImage: "info.circle")
                    Label("support_center".localized, systemImage: "lifepreserver")
                    Label("contact_us".localized, systemImage: "envelope")
                    
                    Button(action: {
                        logout()
                    }) {
                        Label("log_out".localized, systemImage: "arrow.backward.square")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .padding()
            .navigationTitle("profile".localized)
        }
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
}
