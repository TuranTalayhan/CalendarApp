//
//  AssigneePicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 11/03/2025.
//
import FirebaseAuth
import SwiftUI

struct AssigneePicker: View {
    let groups: [Group]
    @Binding var assignee: String
    let auth = Auth.auth()

    var body: some View {
        Picker("Assignee", selection: $assignee) {
            Text("None").tag("")
            ForEach(groups) { group in
                // TODO: Make each selectable member unique
                ForEach(group.members) { member in
                    Text(member.username).tag(member.username)
                }
            }

            if groups.isEmpty {
                Text(auth.currentUser?.displayName ?? "User").tag(auth.currentUser?.displayName ?? "User")
            }

            if assignee != "" {
                Text(assignee).tag(assignee)
            }
        }
    }
}

#Preview {
    AssigneePicker(groups: [], assignee: .constant(""))
}
