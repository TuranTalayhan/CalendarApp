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
    private let firebaseService = FirebaseService.shared

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
        // TODO: HANDLE NILABLE USER
        .navigationDestination(isPresented: $joinGroup) {
            GroupDetailsView(group: Group(name: "Test", members: [firebaseService.currentUser ?? User(id: "failed", username: "failed", email: "failed@gmail.com")]))
        }

        .navigationDestination(isPresented: $createGroup) {
            CreateGroupView()
        }
    }
}

#Preview {
    AddGroupView()
}
