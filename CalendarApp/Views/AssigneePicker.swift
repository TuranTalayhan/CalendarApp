//
//  AssigneePicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 11/03/2025.
//
import FirebaseAuth
import SwiftUI

struct AssigneePicker: View {
    let selectedGroup: String?
    let firebaseService = FirebaseService.shared
    @Binding var assignee: String?
    @State private var members: [User]?
    @State private var group: Group?

    var body: some View {
        Picker("Assignee", selection: $assignee) {
            Text("None").tag(nil as String?)

            if let members = members {
                ForEach(members) { member in
                    Text(member.username).tag(member.id)
                }
            }

            // TODO: HANDLE NILABLE USER
            if members?.count == 0 || members == nil {
                Text(firebaseService.currentUser?.username ?? "Error").tag(firebaseService.currentUser?.id)
            }
        }
        .onChange(of: selectedGroup) {
            Task {
                if let selectedGroup = selectedGroup {
                    group = await firebaseService.fetchGroup(id: selectedGroup)
                }
                // TODO: ADD ERROR HANDLING
                members = try? await firebaseService.fetchUsers(withIDs: group?.members.map(\.id) ?? [])
            }
        }
    }
}

#Preview {
    AssigneePicker(selectedGroup: nil, assignee: .constant(UUID().uuidString))
}
