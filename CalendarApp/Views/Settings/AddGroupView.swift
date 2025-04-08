//
//  AddGroupView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//
import SwiftUI

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var groupID: String = ""
    @State private var joinGroup: Bool = false
    @State private var createGroup: Bool = false
    private let firebaseService = FirebaseService.shared
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    @State private var group: Group?

    var body: some View {
        Form {
            Image("Group")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            Text("Join an existing group or create a new one")
                .listRowBackground(Color.clear)

            Section {
                TextField("Group ID", text: $groupID)
            }
            Button(action: { Task { await addGroup() }}) {
                Text("Join group")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Button(action: { createGroup = true }) {
                Text("Create new group")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
        // TODO: HANDLE NILABLE GROUP
        .navigationDestination(isPresented: $joinGroup) {
            GroupDetailsView(group: group ?? Group(id: "Error", name: "Error", members: []))
        }

        .navigationDestination(isPresented: $createGroup) {
            CreateGroupView()
        }
    }

    private func addGroup() async {
        guard !groupID.isEmpty else { return }
        group = await firebaseService.fetchGroup(id: groupID)
        if let newGroup = group {
            // newGroup.members += [firebaseService.currentUser?.id ?? "Error"]
            group = dataService.addGroup(newGroup.id, newGroup.name, newGroup.members)
            joinGroup = true
        }
    }
}

#Preview {
    AddGroupView()
}
