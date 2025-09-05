//
//  JournalApp.swift
//  Journal
//
//  Created by 조영민 on 6/30/25.
//

import SwiftUI
import SwiftData

@main
struct JournalApp: App {
    @StateObject private var authVM = AuthViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
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
            if authVM.isUnlocked {
                HomeView()
            } else {
                LockScreenView(authVM: authVM)
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if authVM.shouldReauthenticate {
                    authVM.isUnlocked = false
                    authVM.authenicate()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
