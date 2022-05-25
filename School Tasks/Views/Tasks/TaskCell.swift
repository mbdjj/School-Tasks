//
//  TaskCell.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import SwiftUI

struct TaskCell: View {
    
    let task: Task
    let dateString: String
    
    @State var isDone: Bool
    
    @Environment(\.managedObjectContext) var context
    
    init(_ task: Task) {
        let formatter = DateFormatter()
        formatter.dateFormat = String(localized: "date_format")
        dateString = formatter.string(from: task.dateOfCompletion!)
        
        self.task = task
        _isDone = State(initialValue: task.isDone)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    task.isDone.toggle()
                    withAnimation {
                        isDone = task.isDone
                        try? context.save()
                    }
                    NotificationHandler.shared.setBadges()
                } label: {
                    Text(task.title ?? "---")
                        .font(.title2)
                        .bold()
                }
                .foregroundColor(.primary)
                Text("\(task.subject ?? "---")   \(dateString)")
                    .font(.body)
                    .bold()
                    .padding(.vertical, 4)
                Text(task.taskDescription ?? "---")
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            if task.isDone {
                Image(systemName: "checkmark")
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)
            }
        }
    }
}
