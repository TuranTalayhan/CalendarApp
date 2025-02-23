//
//  ContentView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
        }
    }
}

#Preview {
    ContentView()
}
