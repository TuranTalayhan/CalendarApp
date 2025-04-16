//
//  LogInView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct LogInView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorAlert: Bool = false
    private let firebaseService = FirebaseService.shared
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    var body: some View {
        NavigationStack {
            Form {
                Image("Relaxing")
                    .resizable()
                    .scaledToFit()
                    .listRowBackground(Color.clear)

                Section {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                Button(action: { Task {
                    await LogIn()
                }}) {
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
                                NavigationLink("", destination: SignUpView(isLoggedIn: $isLoggedIn, firebaseService: firebaseService))
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
                            NavigationLink("", destination: ResetPasswordView(firebaseService: firebaseService))
                                .opacity(0)
                        }
                }
            }
            .navigationTitle("Log in")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $errorAlert) {
                Alert(title: Text("Invalid Credentials"), message: Text("Please enter a valid email and password."))
            }
        }
    }

    private func LogIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorAlert = true
            return
        }

        do {
            try await firebaseService.LogInChecked(email: email, password: password)

            if let groups = try? await firebaseService.fetchUserGroups() {
                dataService.addGroups(groups)
            }

            let events = await firebaseService.fetchUserEvents()
            dataService.addEvents(events)

            isLoggedIn = true
        } catch {
            print("Login failed: \(error.localizedDescription)")
            errorAlert = true
        }
    }
}

#Preview {
    LogInView(isLoggedIn: .constant(false))
}
