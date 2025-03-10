//
//  LogInView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct LogInView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Image("Relaxing")
                    .resizable()
                    .scaledToFit()
                    .listRowBackground(Color.clear)

                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                Button(action: { isLoggedIn = true }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .tint(.blue)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .listRowBackground(Color.clear)

                Section {
                    HStack {
                        Text("Don't have an account?")
                            .padding(.trailing)
                        Text("Sign up")
                            .foregroundColor(.blue)
                            .overlay {
                                NavigationLink("", destination: SignUpView())
                                    .opacity(0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                    Text("Forgot Password?")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.red)
                        .listRowBackground(Color.clear)
                        .overlay {
                            NavigationLink("", destination: ResetPasswordView())
                                .opacity(0)
                        }
                }
            }
            .navigationTitle("Log in")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LogInView(isLoggedIn: .constant(false))
}
