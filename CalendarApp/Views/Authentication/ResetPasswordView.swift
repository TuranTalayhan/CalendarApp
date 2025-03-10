//
//  ResetPasswordView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""

    var body: some View {
        Form {
            Image("ForgotPassword")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Email", text: $email)
            }

            Button(action: {}) {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    ResetPasswordView()
}
