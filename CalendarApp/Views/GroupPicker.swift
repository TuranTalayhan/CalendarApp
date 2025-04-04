//
//  GroupPicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 02/04/2025.
//

import SwiftUI

struct GroupPicker: View {
    let groups: [Group]
    @Binding var selectedGroup: Group?

    var body: some View {
        Picker("Group", selection: $selectedGroup) {
            Text("None").tag(nil as Group?)
            ForEach(groups) { group in
                Text(group.name).tag(group)
            }
        }
    }
}

#Preview {
    GroupPicker(groups: [Group(id: UUID().uuidString, name: "Group Name", members: [])], selectedGroup: .constant(Group(id: UUID().uuidString, name: "Group Name", members: [])))
}
