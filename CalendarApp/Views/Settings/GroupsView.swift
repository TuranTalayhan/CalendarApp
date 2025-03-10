//
//  GroupsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct GroupsView: View {
    let groups: [Group]

    var body: some View {
        List {
            NavigationLink(destination: GroupDetailsView(group: Group(id: UUID().uuidString, name: "Test Group", members: [User(id: UUID().uuidString, username: "Something", password: "Something", email: "Something")]))) {
                Text("Group 1")
            }
        }
        .navigationTitle(Text("Groups"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button(action: {}) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    GroupsView(groups: [Group(id: UUID().uuidString, name: "Test Group", members: [User(id: UUID().uuidString, username: "Something", password: "Something", email: "Something")])])
}
