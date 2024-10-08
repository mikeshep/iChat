//
//  iChatApp.swift
//  iChat
//
//  Created by Miguel Olmedo on 08/08/24.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct iChatApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
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
                    ContentView()
                }

                #if os(iOS) || os(macOS)

                #endif

                #if os(macOS)
                Settings {
                    ContentView()
                }
                #endif
    }
}
