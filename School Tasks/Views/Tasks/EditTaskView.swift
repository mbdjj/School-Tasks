//
//  EditTaskView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 11/05/2022.
//

import SwiftUI

struct EditTaskView: View {
    
    var task: Task
    
    @State var title: String
    @State var description: String
    
    @State var dateOfComletion: Date
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        return Date() ... calendar.date(byAdding: .year, value: 5, to: Date())!
    }()
    
    @State var isNotifyTurnedOn: Bool
    @State var dateOfNotification: Date
    var notificationRange: ClosedRange<Date> { Date() ... dateOfComletion }
    
    @ObservedObject var model = AddTaskViewModel()
    let handler = NotificationHandler.shared
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateOfCompletion", ascending: true)]) var taskArray: FetchedResults<Task>
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    init(task: Task) {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UIDatePicker.appearance().minuteInterval = 5
        
        self.task = task
        
        _title = State(initialValue: task.title!)
        _description = State(initialValue: task.taskDescription!)
        _dateOfComletion = State(initialValue: task.dateOfCompletion!)
        _isNotifyTurnedOn = State(initialValue: task.notify)
        _dateOfNotification = State(initialValue: task.dateOfNotification!)
        
        model.selectedSubject = task.subject!
        model.setIndex()
    }
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    
                    TextField(text: $title) {
                        Text(String(localized: "add_title"))
                    }
                    
                    TextField(text: $description) {
                        Text(String(localized: "add_description"))
                    }
                    
                }
                
                Section {
                    DatePicker(selection: $dateOfComletion, in: dateRange, displayedComponents: [.date, .hourAndMinute]) {
                        Text(String(localized: "add_due"))
                    }
                }
                
                Section {
                    
                    Toggle(String(localized: "add_notify"), isOn: $isNotifyTurnedOn)
                    
                    if isNotifyTurnedOn {
                        DatePicker(selection: $dateOfNotification, in: notificationRange, displayedComponents: [.date, .hourAndMinute]) {
                            Text(String(localized: "add_when"))
                        }
                    }
                    
                }
                
                Section {
                    NavigationLink {
                        ChooseSubjectView(model: model)
                    } label: {
                        HStack {
                            Text(String(localized: "add_subject"))
                            
                            Spacer()
                            
                            Text(model.selectedSubject)
                                .foregroundColor(Color(uiColor: .systemGray))
                        }
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle(String(localized: "edit_nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text(String(localized: "cancel"))
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        let newTask = Task(context: context)
                        newTask.title = title
                        newTask.taskDescription = description
                        newTask.dateOfCompletion = dateOfComletion
                        newTask.notify = isNotifyTurnedOn
                        newTask.dateOfNotification = dateOfNotification
                        newTask.subject = model.selectedSubject
                        newTask.uuid = task.uuid
                        newTask.isDone = task.isDone
                        
                        handler.deleteNotification(about: task)
                        
                        if newTask.notify {
                            handler.sheduleNotification(about: newTask)
                        } else {
                            
                        }
                        
                        dismiss()
                        
                        context.delete(task)
                        
                        withAnimation {
                            try? context.save()
                        }
                    } label: {
                        Text(String(localized: "save"))
                            .bold()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onChange(of: isNotifyTurnedOn) { newValue in
                if newValue {
                    handler.requestNotificationPermission()
                }
            }
        }
    }
}
