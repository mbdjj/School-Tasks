//
//  ContentView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 09/05/2022.
//

import SwiftUI

struct AddTaskView: View {
    
    @State var title = ""
    @State var description = ""
    
    @State var dateOfComletion: Date
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        return Date() ... calendar.date(byAdding: .year, value: 5, to: Date())!
    }()
    
    @State var isNotifyTurnedOn = false
    @State var dateOfNotification = Date()
    var notificationRange: ClosedRange<Date> { Date() ... dateOfComletion }
    
    @ObservedObject var model = AddTaskViewModel()
    var tasksModel: TasksViewModel
    var handler = NotificationHandler.shared
    //var manager = CoreDataManager.shared
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var shouldDisplayAlert = false
    
    init(tasksModel: TasksViewModel) {
        self.tasksModel = tasksModel
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UIDatePicker.appearance().minuteInterval = 5
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        
        components.hour! += 1
        components.minute = 0
        
        _dateOfComletion = State(initialValue: Calendar.current.date(from: components) ?? Date())
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
            .navigationTitle(String(localized: "add_nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        if !tasksModel.shouldBlockDismissalOfSheet {
                            dismiss()
                        } else {
                            shouldDisplayAlert.toggle()
                        }
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
                        newTask.uuid = UUID()
                        newTask.isDone = false
                        
                        if newTask.notify {
                            handler.sheduleNotification(about: newTask)
                        }
                        
                        withAnimation {
                            try? context.save()
                        }
                        
                        tasksModel.shouldBlockDismissalOfSheet = false
                        
                        dismiss()
                    } label: {
                        Text(String(localized: "add"))
                            .bold()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert(String(localized: "sure?"), isPresented: $shouldDisplayAlert) {
                Button(String(localized: "y"), role: .destructive) {
                    tasksModel.shouldBlockDismissalOfSheet = false
                    dismiss()
                }
                
                Button(String(localized: "n"), role: .cancel) { shouldDisplayAlert.toggle() }
            }
            .onChange(of: isNotifyTurnedOn) { newValue in
                if newValue {
                    handler.requestNotificationPermission()
                }
            }
            .onChange(of: title.isEmpty) { newValue in
                if newValue {
                    tasksModel.shouldBlockDismissalOfSheet = false
                } else {
                    tasksModel.shouldBlockDismissalOfSheet = true
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(tasksModel: TasksViewModel())
    }
}
