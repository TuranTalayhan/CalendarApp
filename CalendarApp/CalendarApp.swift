//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 19/02/2025.
//

import FirebaseCore
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CalendarApp: App {
    @State var isLoggedIn = false
    @State var hasLoaded = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self,
            Group.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn, hasLoaded: $hasLoaded)
                .onAppear {
                    FirebaseService.shared.addAuthStateListener { user in
                        if user != nil {
                            print(user?.email ?? "No user")
                            isLoggedIn = true
                        } else {
                            isLoggedIn = false
                        }
                        hasLoaded = true
                    }
                }
                .onDisappear {
                    FirebaseService.shared.removeAuthStateListener()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
