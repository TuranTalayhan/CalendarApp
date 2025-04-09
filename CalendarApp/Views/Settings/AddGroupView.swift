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
        guard let userID = firebaseService.currentUser?.id else {
            print("Error: No current user ID")
            return
        }

        let stringUserID = StringID(userID)

        group = await firebaseService.fetchGroup(id: groupID)
        if let newGroup = group {
            if !newGroup.members.contains(stringUserID) {
                newGroup.members.append(stringUserID)
            }
            group = dataService.addGroup(newGroup.id, newGroup.name, newGroup.members)
            firebaseService.saveGroup(newGroup)
            joinGroup = true
        }
    }
}

#Preview {
    AddGroupView()
}
