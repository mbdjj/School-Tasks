//
//  AppDelegate.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @Environment(\.managedObjectContext) var context
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("App Did Finish Launching With Options")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        try? context.save()
    }
    
}
