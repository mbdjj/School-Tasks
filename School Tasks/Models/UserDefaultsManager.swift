//
//  UserDefaultsManager.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 12/05/2022.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    
    @Published var subjectArray: [String]
    @Published var hideDone: Bool
    
    let defaults = UserDefaults.standard
    
    static let shared = UserDefaultsManager()
    
    init() {
        self.subjectArray = defaults.array(forKey: "subjectArray") as? [String] ?? ["---"]
        self.hideDone = defaults.bool(forKey: "hideDone")
    }
    
    //MARK: - methods
    
    func saveSubjectArray() {
        defaults.set(subjectArray, forKey: "subjectArray")
    }
    
    func saveHideDone() {
        defaults.set(hideDone, forKey: "hideDone")
    }
    
}
