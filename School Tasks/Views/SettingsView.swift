//
//  SettingsView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 12/05/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var defaultsManager = UserDefaultsManager.shared
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    
                    Toggle(String(localized: "settings_hide_done"), isOn: $defaultsManager.hideDone)
                    
                }
                
            }
            .navigationTitle(String(localized: "settings"))
            .onChange(of: defaultsManager.hideDone) { _ in
                defaultsManager.saveHideDone()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
