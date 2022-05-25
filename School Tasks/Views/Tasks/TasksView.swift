//
//  TasksView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import SwiftUI

struct TasksView: View {
    
    @State var shouldPresentAddTaskSheet = false
    
    @ObservedObject var model = TasksViewModel()
    let handler = NotificationHandler.shared
    @ObservedObject var defaultsManager = UserDefaultsManager.shared
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "isDone", ascending: true), NSSortDescriptor(key: "dateOfCompletion", ascending: true)]) var taskArray: FetchedResults<Task>
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            if taskArray.isEmpty {
                ScrollView {
                    Text(String(localized: "no_tasks_1"))
                        .font(.title)
                        .bold()
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text(String(localized: "no_tasks_2"))
                        .font(.title3)
                        .padding(.horizontal)
                }
                .navigationTitle(String(localized: "tasks"))
                .toolbar {
                    Button {
                        shouldPresentAddTaskSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            } else {
                List(taskArray) { task in
                    TaskCell(task)
                        .contextMenu {
                            CellContextMenu(for: task, model: model)
                        }
                }
                .navigationTitle(String(localized: "tasks"))
                .toolbar {
                    Button {
                        shouldPresentAddTaskSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $shouldPresentAddTaskSheet) {
            AddTaskView(tasksModel: model)
                .interactiveDismissDisabled(model.shouldBlockDismissalOfSheet)
        }
        .sheet(item: $model.selectedTask) { task in
            EditTaskView(task: task)
        }
        .onAppear() {
            updateNSPredicate()
        }
        .onChange(of: defaultsManager.hideDone, perform: { newValue in
            updateNSPredicate()
            checkForOldTasks()
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            checkForOldTasks()
        }
    }
    
    //MARK: - TasksView methods
    
    func checkForOldTasks() {
        handler.taskArray = taskArray
        
        for task in taskArray {
            if task.dateOfCompletion! < Date() {
                withAnimation {
                    context.delete(task)
                    try? context.save()
                }
            }
        }
        
        handler.setBadges()
    }
    
    func updateNSPredicate() {
        if defaultsManager.hideDone {
            taskArray.nsPredicate = NSPredicate(format: "isDone == false")
        } else {
            taskArray.nsPredicate = nil
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
