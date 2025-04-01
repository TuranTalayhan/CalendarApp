//
//  SettingsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
    @Binding var isLoggedIn: Bool
    var firebaseService: FirebaseService = .shared
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: UserView(isLoggedIn: $isLoggedIn)) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipped(antialiased: true)
                        // TODO: HANDLE NILABLE USER
                        Text(firebaseService.currentUser?.username ?? "Failed").tag(firebaseService.currentUser?.username ?? "Failed")
                    }
                }

                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView(isLoggedIn: .constant(true))
}
