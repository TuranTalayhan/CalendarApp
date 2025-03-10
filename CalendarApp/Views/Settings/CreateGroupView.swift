//
//  CreateGroupView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct CreateGroupView: View {
    @State private var groupName: String = ""
    var body: some View {
        Form {
            Image("Group2")
                .resizable()
                .scaledToFit()
                .listRowBackground(Color.clear)

            Section {
                TextField("Group Name", text: $groupName)
            }

            Button(action: {}) {
                Text("Create Group")
                    .frame(maxWidth: .infinity)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    CreateGroupView()
}
