//
//  RegisterView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorAlert: Bool = false
    @Binding var isLoggedIn: Bool
    let firebaseService: FirebaseService
    var body: some View {
        Form {
            Image("Relaxing")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
            }

            Button(action: { SignUp()
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
        .navigationTitle(Text("Sign Up"))
        .alert(isPresented: $errorAlert) {
            Alert(title: Text("Invalid Credentials"), message: Text("Please enter a valid email, username and password."))
        }
    }

    private func SignUp() {
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty else {
            errorAlert = true
            return
        }

        firebaseService.RegisterWithEmail(username, email, password) { error in
            if let error = error {
                print("SignUp failed: \(error.localizedDescription)")
                errorAlert = true
                return
            }
            isLoggedIn = true
        }
    }
}

#Preview {
    SignUpView(isLoggedIn: .constant(false), firebaseService: FirebaseService())
}
