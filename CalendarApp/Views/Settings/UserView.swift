//
//  UserView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftData
import SwiftUI

struct UserView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @Query private var events: [Event]
    @Binding var isLoggedIn: Bool
    @State private var alert: Bool = false
    private let firebaseService = FirebaseService.shared
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    var body: some View {
        List {
            NavigationLink(destination: GroupsView()) {
                Text("Groups")
            }
            Button(action: {
                alert = true
            }) {
                Text("Log out")
            }
            .foregroundStyle(.red)
        }
        .alert("Are you sure you want to log out?", isPresented: $alert, actions: {
            Button("Log out", role: .destructive) { LogOut() }
        })
    }

    private func LogOut() {
        dataService.deleteGroups(groups)
        dataService.deleteEvents(events)
        firebaseService.removeListeners()
        firebaseService.signOut()
        isLoggedIn = false
    }
}

#Preview {
    UserView(isLoggedIn: .constant(true))
}
