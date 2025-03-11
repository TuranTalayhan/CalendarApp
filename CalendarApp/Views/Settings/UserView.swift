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
            NavigationLink(destination: GroupsView()) {
                Text("Groups")
            }
        }
    }
}

#Preview {
    UserView()
}
