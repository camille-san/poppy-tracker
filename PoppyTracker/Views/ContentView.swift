//
//  ContentView.swift
//  PoppyTracker
//
//  Created by Camille on 15/3/24.
//

import SwiftUI

struct ContentView: View {

    @State private var selection: Tab = .calendar

    enum Tab {
        case calendar
        case user
    }

    var body: some View {
        TabView(selection: $selection) {
            CalendarPageView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                    }
                }
                .tag(Tab.calendar)
            UserView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                    }
                }
                .tag(Tab.user)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    return ContentView()
        .environment(ModelData())
}
