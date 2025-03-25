//
//  ContentView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false
    private let firebaseService = FirebaseService.shared

    init() {
        self.isLoggedIn = firebaseService.getCurrentUser() != nil
    }

    var body: some View {
        if !isLoggedIn {
            LogInView(isLoggedIn: $isLoggedIn)
        } else {
            TabView {
                EventsView()
                    .tabItem {
                        Image(systemName: "mappin")
                        Text("Events")
                    }

                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
