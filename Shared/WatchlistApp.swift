//
//  WatchlistApp.swift
//  Shared
//
//  Created by Thura Soe Win on 22/5/21.
//

import SwiftUI

@main
struct WatchlistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        let mainWindow = WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        #if os(macOS)
            mainWindow
                .commands {
                    MenuCommands()
                }
                .windowStyle(HiddenTitleBarWindowStyle())
                .windowToolbarStyle(UnifiedWindowToolbarStyle())
        #else
            mainWindow
        #endif
    }
}
