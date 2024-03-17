//
//  CalendarPageView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct CalendarPageView: View {

    @Environment(ModelData.self) var modelData

    @State private var month = 2
    @State private var year = 1989
    @State private var dayPositions: [Date : CGRect] = [:]

    //    @State private var startDate : Date?
    //    @State private var endDate : Date?
    @State private var tempSelectedDates : [Date] = []

    private var size : CGFloat = 45
    private var dateFormatter : DateFormatter = DateFormatter()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    func onClickDate(date : DateContainer) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()

        let unwrappedDate : Date = date.date!
        if modelData.selectedDates.contains(unwrappedDate) {
            modelData.selectedDates.remove(unwrappedDate)
        } else {
            modelData.selectedDates.insert(unwrappedDate)
        }

        generator.impactOccurred()
    }

    func selectDatesBasedOnCGPoints(startPoint : CGPoint, endPoint: CGPoint) {

        let newStartPoint = CGPoint(x: startPoint.x, y: startPoint.y + size)
        let newEndPoint = CGPoint(x: endPoint.x, y: endPoint.y + size)

        var startDate : Date?
        var endDate : Date?
        for (date, cgRect) in dayPositions {
            if cgRect.contains(newStartPoint) {
                startDate = date
            } else if cgRect.contains(newEndPoint) {
                endDate = date
            }

            if let unwrappedStartDate = startDate, let unwrappedEndDate = endDate {
                let selectedDates = datesBetween(startDate: unwrappedStartDate, endDate: unwrappedEndDate)
                tempSelectedDates = selectedDates
                break
            }
        }
    }

    func selectDateRange() {
        if modelData.selectedDates.isSuperset(of: tempSelectedDates) {
            modelData.selectedDates.subtract(tempSelectedDates)
        } else {
            modelData.selectedDates.formUnion(tempSelectedDates)
        }
        tempSelectedDates = []
    }

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
            LazyVGrid(columns: columns) {
                ForEach(getDays(month: month, year: year)) { day in
                    CalendarDayView(date: day, size: size) { rect in
                        if let unwrappedDate = day.date {
                            dayPositions[unwrappedDate] = rect
                        }
                    }
                    .overlay{
                        if day.isFilled && tempSelectedDates.contains(day.date!) {
                            Color.orange
                                .opacity(0.2)
                                .clipShape(Circle())
                        }
                    }
                    .frame(width: size, height: size)
                    .onTapGesture {
                        if day.isFilled {
                            onClickDate(date: day)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .onChange(of: month) {
            dayPositions = [:]
        }
        .gesture(DragGesture()
            .onChanged { value in
                selectDatesBasedOnCGPoints(
                    startPoint: value.startLocation,
                    endPoint: value.location)
            }
            .onEnded {value in
                selectDatesBasedOnCGPoints(
                    startPoint: value.startLocation,
                    endPoint: value.location)
                selectDateRange()
            }
        )
    }
}

#Preview {
    CalendarPageView()
        .environment(ModelData())
}
