//
//  ContentView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @Binding var hasLoaded: Bool

    var body: some View {
        if !hasLoaded {
            ProgressView()
        } else if !isLoggedIn {
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
                SettingsView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
        }
    }
}

#Preview {
    ContentView(isLoggedIn: .constant(true), hasLoaded: .constant(true))
}
