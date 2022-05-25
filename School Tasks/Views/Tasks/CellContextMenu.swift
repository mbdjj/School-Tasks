//
//  CellContextMenu.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 11/05/2022.
//

import SwiftUI

struct CellContextMenu: View {
    
    let task: Task
    let model: TasksViewModel
    let handler = NotificationHandler.shared
    
    @Environment(\.managedObjectContext) var context
    
    init(for task: Task, model: TasksViewModel) {
        self.task = task
        self.model = model
    }
    
    var body: some View {
        Group {
            
            Button {
                model.selectedTask = task
            } label: {
                Label(String(localized: "edit"), systemImage: "slider.horizontal.3")
            }
            
            Button(role: .destructive) {
                handler.deleteNotification(about: task)
                
                withAnimation {
                    context.delete(task)
                    try? context.save()
                }
                
                handler.setBadges()
            } label: {
                Label(String(localized: "delete"), systemImage: "trash")
            }
            
        }
    }
}
