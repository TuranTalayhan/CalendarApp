//
//  GroupsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftData
import SwiftUI

struct GroupsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @State private var showAddGroupView: Bool = false
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    var body: some View {
        List {
            ForEach(groups) { group in
                NavigationLink(destination: GroupDetailsView(group: group)) {
                    Text(group.name)
                }
            }
            .onDelete(perform: deleteGroups)
        }
        .navigationTitle(Text("Groups"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button(action: { showAddGroupView = true }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationDestination(isPresented: $showAddGroupView) {
            AddGroupView()
        }
    }

    private func deleteGroups(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                FirebaseService.shared.deleteGroup(id: groups[index].id)
                dataService.deleteGroup(groups[index])
            }
        }
    }
}

#Preview {
    GroupsView()
}
