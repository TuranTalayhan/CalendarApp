//
//  GroupPicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 02/04/2025.
//

import SwiftUI

struct GroupPicker: View {
    let groups: [Group]
    @Binding var selectedGroup: String?

    var body: some View {
        Picker("Group", selection: $selectedGroup) {
            Text("None").tag(nil as String?)
            
            ForEach(groups) { group in
                Text(group.name).tag(group.id)
            }
        }
    }
}

#Preview {
    GroupPicker(groups: [Group(id: UUID().uuidString, name: "Group Name", members: [])], selectedGroup: .constant(""))
}
