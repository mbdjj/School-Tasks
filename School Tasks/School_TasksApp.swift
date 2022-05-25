//
//  School_TasksApp.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 09/05/2022.
//

import SwiftUI

@main
struct School_TasksApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
