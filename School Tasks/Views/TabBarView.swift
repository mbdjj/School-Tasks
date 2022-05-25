//
//  TabBarView.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 12/05/2022.
//

import SwiftUI

struct TabBarView: View {
    
    @State var tabBarSelection = 0
    
    var body: some View {
        TabView(selection: $tabBarSelection) {
            TasksView()
                .tabItem {
                    Label(String(localized: "tasks"), systemImage: "calendar")
                }
                .tag(0)
            SettingsView()
                .tabItem {
                    Label(String(localized: "settings"), systemImage: "gear")
                }
                .tag(1)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
