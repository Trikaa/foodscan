import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("create_account".localized)
                .font(.largeTitle)
                .bold()

            TextField("email".localized, text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("password".localized, text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("confirm_password".localized, text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("register".localized) {
                register()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("registration_failed".localized),
                message: Text("passwords_do_not_match".localized),
                dismissButton: .default(Text("ok".localized))
            )
        }
    }

    func register() {
        guard password == confirmPassword else {
            showAlert = true
            return
        }

        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        isLoggedIn = true
    }
}
