//
//  MelodyMateApp.swift
//  MelodyMate
//
//  Created by shay moreno on 23/05/2023.
//

import SwiftUI

@main
struct MelodyMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
