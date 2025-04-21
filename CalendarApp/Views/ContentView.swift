//
//  ContentView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isLoggedIn: Bool
    @Binding var hasLoaded: Bool
    private let firebaseService = FirebaseService.shared
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

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
            .onAppear {
                firebaseService.listenToUserGroups { groups in
                    dataService.replaceGroups(with: groups)
                }

                firebaseService.listenToUserEvents { events in
                    dataService.replaceEvents(with: events)
                }
            }
            .onDisappear {
                firebaseService.removeListeners()
            }
        }
    }
}

#Preview {
    ContentView(isLoggedIn: .constant(true), hasLoaded: .constant(true))
}
