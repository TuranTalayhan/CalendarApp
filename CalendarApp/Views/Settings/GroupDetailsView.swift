//
//  GroupDetailsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct GroupDetailsView: View {
    let group: Group
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var showingConfirmation: Bool = false
    @State private var showCopiedMessage = false
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    var body: some View {
        ZStack {
            List {
                Section("Name") {
                    Text(group.name)
                }

                Section(header: Text("Group ID"), footer: showCopiedMessage ? Text("Copied")
                    .foregroundColor(.secondary)
                    : Text(" "))
                {
                    Button(action: {
                        UIPasteboard.general.string = group.id
                        showCopiedMessage = true

                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            showCopiedMessage = false
                        }
                    }) {
                        Text(group.id)
                            .foregroundColor(.primary)
                    }
                }

                Section("Members") {
                    ForEach(group.members) { member in
                        Text(member.username)
                    }
                }
                Button(role: .destructive, action: { showingConfirmation = true }) {
                    Text("Delete Group")
                }
                .confirmationDialog("Are you sure you want to delete this group?", isPresented: $showingConfirmation, titleVisibility: .visible) {
                    Button("Delete Group", role: .destructive, action: deleteGroup)
                    Button("Cancel", role: .cancel, action: {})
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
            }
        }
        .navigationTitle(Text("Group details"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func deleteGroup() {
        withAnimation {
            FirebaseService.shared.deleteGroup(id: group.id)
            dataService.deleteGroup(group)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    GroupDetailsView(group: Group(id: UUID().uuidString, name: "Test Group", members: [User(id: "id1", username: "User1", email: "test@test.com"), User(id: "id2", username: "User3", email: "test@test.com"), User(id: "id3", username: "User2", email: "test@test.com"), User(id: "id4", username: "User3", email: "test@test.com")]))
}
