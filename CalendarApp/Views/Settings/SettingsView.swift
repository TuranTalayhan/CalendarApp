//
//  SettingsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: UserView()) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipped(antialiased: true)
                        // TODO: HANDLE NILABLE USER
                        Text(FirebaseService.shared.getCurrentUser()?.username ?? "Failed")
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
    SettingsView()
}
