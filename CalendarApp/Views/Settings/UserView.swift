//
//  UserView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        List {
            NavigationLink(destination: GroupsView(groups: [Group(id: UUID().uuidString, name: "Test Group", members: [User(id: UUID().uuidString, username: "Something", password: "Something", email: "Something")])])) {
                Text("Groups")
            }
        }
    }
}

#Preview {
    UserView()
}
