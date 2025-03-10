//
//  GroupsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct GroupsView: View {
    var body: some View {
        List {
            NavigationLink(destination: GroupDetailsView()) {
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
    GroupsView()
}
