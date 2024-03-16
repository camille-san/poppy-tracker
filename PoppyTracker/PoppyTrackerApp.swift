//
//  PoppyTrackerApp.swift
//  PoppyTracker
//
//  Created by Camille on 15/3/24.
//

import SwiftUI

@main
struct PoppyTrackerApp: App {

    @State private var modelData = ModelData()
    @State private var userStatistics = UserStatistics()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
                .environment(userStatistics)
        }
    }
}
