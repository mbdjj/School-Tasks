//
//  AddTaskViewModel.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import Foundation
import SwiftUI

class AddTaskViewModel: ObservableObject {
    
    @Published var selectedSubject = "---"
    @Published var selectedSubjectIndex = 0
    
    @ObservedObject var defaultsManager = UserDefaultsManager.shared
    
    //MARK: - methods
    
    func addNewSubject(_ name: String) {
        defaultsManager.subjectArray.append(name)
        defaultsManager.subjectArray.sort()
        selectedSubject = defaultsManager.subjectArray[0]
        selectedSubjectIndex = 0
        
        defaultsManager.saveSubjectArray()
    }
    
    func setIndex() {
        selectedSubjectIndex = defaultsManager.subjectArray.firstIndex(of: selectedSubject) ?? 0
    }
    
}
