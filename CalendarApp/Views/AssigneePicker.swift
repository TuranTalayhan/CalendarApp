//
//  AssigneePicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 11/03/2025.
//
import FirebaseAuth
import SwiftUI

struct AssigneePicker: View {
    let group: Group?
    let firebaseService = FirebaseService.shared
    @Binding var assignee: User?
    @State private var members: [User]?

    var body: some View {
        if let members = members {
            Picker("Assignee", selection: $assignee) {
                Text("None").tag(nil as User?)

                if !members.isEmpty {
                    ForEach(members) { member in
                        Text(member.username).tag(member)
                    }
                } else {
                    // TODO: HANDLE NILABLE USER
                    Text(firebaseService.currentUser?.username ?? "Failed").tag(firebaseService.currentUser as User?)
                }

                if let assignee = assignee {
                    Text(assignee.username).tag(assignee)
                }
            }
        } else {
            ProgressView()
                .task {
                    // TODO: ADD ERROR HANDLING
                    members = try? await FirebaseService.shared.fetchUsers(withIDs: group?.members.map(\.id) ?? [])
                }
        }
    }
}

#Preview {
    AssigneePicker(group: nil, assignee: .constant(User(id: "id5", username: "username", email: "email")))
}
