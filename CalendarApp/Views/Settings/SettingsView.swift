//
//  SettingsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: UserView()) {
                    HStack {
                        Image("Relaxing")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .clipped(antialiased: true)
                        Text("Username")
                    }
                }

                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
            }
        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    SettingsView()
}
