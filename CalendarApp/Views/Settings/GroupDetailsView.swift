//
//  GroupDetailsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct GroupDetailsView: View {
    let group: Group

    var body: some View {
        List {
            Section("Name") {
                Text(group.name)
            }

            Section("Group id") {
                Text(group.id)
            }

            Section("Members") {
                ForEach(group.members) { member in
                    Text(member.username)
                }
            }
        }
        .navigationTitle(Text("Group details"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GroupDetailsView(group: Group(id: UUID().uuidString, name: "Test Group", members: [User(id: UUID().uuidString, username: "Member 1", password: "Something", email: "Something"), User(id: UUID().uuidString, username: "Member 2", password: "Something", email: "Something")]))
}
