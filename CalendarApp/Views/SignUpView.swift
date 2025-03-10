//
//  RegisterView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        Form {
            Image("Relaxing")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Email", text: $email)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            }

            Button(action: {}) {
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
    }
}

#Preview {
    SignUpView()
}
