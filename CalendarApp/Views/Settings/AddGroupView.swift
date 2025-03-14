//
//  AddGroupView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import FirebaseAuth
import SwiftUI

struct AddGroupView: View {
    @State private var groupID: String = ""
    @State private var joinGroup: Bool = false
    @State private var createGroup: Bool = false
    private let auth = Auth.auth()

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
            Button(action: { joinGroup = true }) {
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
        .navigationDestination(isPresented: $joinGroup) {
            GroupDetailsView(group: Group(name: "Test", members: [User(username: auth.currentUser?.displayName ?? "User")]))
        }

        .navigationDestination(isPresented: $createGroup) {
            CreateGroupView(auth: auth)
        }
    }
}

#Preview {
    AddGroupView()
}
