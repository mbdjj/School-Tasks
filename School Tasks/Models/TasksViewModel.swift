//
//  TasksViewModel.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import Foundation

class TasksViewModel: ObservableObject {
    
    @Published var shouldBlockDismissalOfSheet = false
    
    @Published var selectedTask: Task? = nil
    
}
