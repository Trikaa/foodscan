import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Text("welcome".localized)
                    .font(.largeTitle)
                    .bold()

                TextField("email".localized, text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                SecureField("password".localized, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("login".localized) {
                    login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                NavigationLink("no_account_register".localized, destination: RegisterView())
                    .padding()
                    .onAppear {
                        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "No Email"
                        let password = UserDefaults.standard.string(forKey: "userPassword") ?? "No Password"
                        let fullName = UserDefaults.standard.string(forKey: "userFullName") ?? "No Name"

                        print("Email: \(email)")
                        print("Password: \(password)")
                        print("Full Name: \(fullName)")
                    }

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("login_failed".localized),
                    message: Text("invalid_credentials".localized),
                    dismissButton: .default(Text("ok".localized))
                )
            }
        }
    }

    func login() {
        let savedEmail = UserDefaults.standard.string(forKey: "email")
        let savedPassword = UserDefaults.standard.string(forKey: "password")

        if email == savedEmail && password == savedPassword {
            isLoggedIn = true
        } else {
            showAlert = true
        }
    }
}
