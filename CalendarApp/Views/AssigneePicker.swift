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

    var body: some View {
        Picker("Assignee", selection: $assignee) {
            Text("None").tag(nil as User?)

            if let group = group {
                // TODO: Make each selectable member unique
                ForEach(group.members) { member in
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
    }
}

#Preview {
    AssigneePicker(group: nil, assignee: .constant(User(username: "username", email: "email")))
}
