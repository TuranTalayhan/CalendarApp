//
//  RegisterView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Form {
            Image("Relaxing")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Email", text: .constant(""))
                TextField("Username", text: .constant(""))
                SecureField("Password", text: .constant(""))
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

            Section {
                HStack {
                    Text("Already have an account?")
                        .padding(.trailing)
                    Button("Log in") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(Text("Sign Up"))
    }
}

#Preview {
    SignUpView()
}
