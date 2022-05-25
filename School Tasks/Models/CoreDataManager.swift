//
//  CoreDataManager.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import UIKit
import CoreData
import SwiftUI

class CoreDataManager: ObservableObject {
    
    let container = NSPersistentContainer(name: "DataModel")
    
    static let shared = CoreDataManager()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
}
