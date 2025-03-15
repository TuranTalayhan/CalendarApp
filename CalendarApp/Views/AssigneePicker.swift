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
    let firebaseService = FirebaseService.shared
    @Binding var assignee: String

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
                Text(firebaseService.getCurrentUserDisplayName() ?? "User").tag(firebaseService.getCurrentUserDisplayName() ?? "User")
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
