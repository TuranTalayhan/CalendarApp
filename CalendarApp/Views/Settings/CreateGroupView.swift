//
//  CreateGroupView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var groupName: String = ""
    @State private var createdGroupName = ""
    @State private var invalidName: Bool = false
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    @State private var isPresented: Bool = false

    var body: some View {
        Form {
            Image("Group2")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Group Name", text: $groupName)
            }

            Button(action: createGroup) {
                Text("Create Group")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
        .navigationDestination(isPresented: $isPresented) {
            GroupDetailsView(group: Group(name: createdGroupName, members: ["User1"]))
        }
        .alert(isPresented: $invalidName) {
            Alert(title: Text("Error"), message: Text("Group name cannot be empty"))
        }
    }

    private func createGroup() {
        guard !groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            invalidName = true
            return
        }
        dataService.addGroup(groupName, ["User1"])
        createdGroupName = groupName
        groupName = ""
        isPresented = true
    }
}

#Preview {
    CreateGroupView()
}
