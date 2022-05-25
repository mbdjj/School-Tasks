//
//  ChooseSubjectView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import SwiftUI

struct ChooseSubjectView: View {
    
    @State var newSubject = ""
    @State var shouldDisplayTextField = false
    
    @ObservedObject var model: AddTaskViewModel
    @ObservedObject var defaultsManager = UserDefaultsManager.shared
    
    var body: some View {
        List {
            ForEach(defaultsManager.subjectArray, id: \.self) { subject in
                
                HStack {
                    Button {
                        model.selectedSubject = subject
                        DispatchQueue.main.async {
                            model.selectedSubjectIndex = defaultsManager.subjectArray.firstIndex(of: subject)!
                        }
                    } label: {
                        Text(subject)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    if model.selectedSubjectIndex ==  defaultsManager.subjectArray.firstIndex(of: subject) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                
            }
            .onDelete { indexSet in
                defaultsManager.subjectArray.remove(atOffsets: indexSet)
                defaultsManager.saveSubjectArray()
            }
            
            if shouldDisplayTextField {
                TextField(String(localized: "choose_new"), text: $newSubject)
                    .submitLabel(.done)
                    .onSubmit {
                        model.addNewSubject(newSubject)
                        newSubject = ""
                        shouldDisplayTextField = false
                    }
            }
        }
        .animation(.default, value: shouldDisplayTextField)
        .navigationTitle(String(localized: "choose_nav_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                shouldDisplayTextField = true
            } label: {
                Image(systemName: "plus")
            }
            .disabled(shouldDisplayTextField)
        }
    }
}

struct ChooseSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseSubjectView(model: AddTaskViewModel())
        }
    }
}
