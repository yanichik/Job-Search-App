//
//  UnibuiAssignmentApp.swift
//  UnibuiAssignment
//
//  Created by admin on 9/12/24.
//

import SwiftUI

@main
struct UnibuiAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OpenJobsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
