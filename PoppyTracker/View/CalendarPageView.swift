//
//  CalendarPageView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct CalendarPageView: View {

    @State private var month = 11
    @State private var year = 1989

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            Picker(selection: $month, label: Text("Picker")) {
                ForEach(Month.allCases, id: \.monthIndex) { month in
                    Text("\(month.monthIndex)").tag(month.monthIndex)
                }
            }
            .pickerStyle(.segmented)
            Text("Month: \(month)")
            LazyVGrid(columns: columns, spacing: 20) {
                Text("L")
                Text("M")
                Text("M")
                Text("J")
                Text("V")
                Text("S")
                Text("D")
            }
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(getDays(month: month, year: year)) { day in
                    CalendarDayView(date: day)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CalendarPageView()
        .environment(ModelData())
}
