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
                ForEach(group.members, id: \.self) { member in
                    Text(member)
                }
            }
        }
        .navigationTitle(Text("Group details"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GroupDetailsView(group: Group(name: "Test Group", members: ["User1", "User2", "User3"]))
}
