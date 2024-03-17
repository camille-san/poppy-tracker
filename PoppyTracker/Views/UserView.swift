//
//  UserView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct UserView: View {

    @Environment(UserStatistics.self) var userStatistics
    @Environment(ModelData.self) var modelData

    var body: some View {
        VStack {
            Text("\(userStatistics.usualPeriodLength)")
            Text("\(modelData.selectedDates.count)")
        }
    }
}

#Preview {
    UserView()
        .environment(UserStatistics())
        .environment(ModelData())
}
