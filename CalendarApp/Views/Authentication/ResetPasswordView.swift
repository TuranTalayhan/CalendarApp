//
//  ResetPasswordView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    let firebaseService: FirebaseService
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = ""
    @State private var errorAlert: Bool = false

    var body: some View {
        Form {
            Image("ForgotPassword")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Email", text: $email)
            }

            Button(action: { ResetPassword() }) {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
        .alert(isPresented: $errorAlert) {
            Alert(title: Text("Email isn't registered"), message: Text("Please check the email or sign up for a new account."))
        }
    }

    private func ResetPassword() {
        guard !email.isEmpty else {
            errorAlert = true
            return
        }
        firebaseService.ResetPassword(email) { error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                errorAlert = true
                return
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ResetPasswordView(firebaseService: FirebaseService.shared)
}
