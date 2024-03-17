//
//  CalendarPageView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct CalendarPageView: View {

    @Environment(ModelData.self) var modelData

    @State private var month = Calendar.current.component(.month, from: Date())
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var dayPositions: [Date : CGRect] = [:]
    @State private var tempSelectedDates : [Date] = []

    private let size : CGFloat = 45
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let calendar = Calendar.current
    private let todayYear = Calendar.current.component(.year, from: Date())
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

    var body: some View {
        VStack (spacing: 32) {
            Text("Calendar")
                .font(.title)
                .padding(.top, 24)
            HStack {
                Picker(selection: $month, label: Text("Month picker")) {
                    ForEach(Month.allCases, id: \.monthIndex) { month in
                        Text("\(month.monthIndex)").tag(month.monthIndex)
                    }
                }
                .pickerStyle(.wheel)
                Picker(selection: $year, label: Text("Year picker")) {
                    ForEach(Array((todayYear-3)...(todayYear+2)), id: \.self) { year in
                        Text("\(String(year))").tag(year)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 100)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack (spacing: 32) {
                LazyVGrid(columns: columns, spacing: 20) {
                    Group {
                        Text("M")
                        Text("T")
                        Text("W")
                        Text("T")
                        Text("F")
                        Text("S")
                        Text("S")
                    }
                    .foregroundColor(.gray)
                    .bold()
                }
                LazyVGrid(columns: columns) {
                    ForEach(getDays(month: month, year: year)) { day in
                        CalendarDay(date: day, size: size) { rect in
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
                        .overlay {
                            if day.isFilled && calendar.isDateInToday(day.date!) {
                                Circle().stroke(.pink, lineWidth: 2)
                            }
                        }
                        .frame(width: size, height: size)
                        .onTapGesture {onClickDate(date: day)}
                    }
                }
            }
            .padding()
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
        }
        .padding()
        .onChange(of: month) {
            dayPositions = [:]
        }
        .onChange(of: year) {
            dayPositions = [:]
        }
        .background(PinkGradientBackground())
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

    private func onClickDate(date : DateContainer) {
        if date.isFilled {
            generator.prepare()
            modelData.handleOneDate(date: date.date!)
            generator.impactOccurred()
        }
    }

    private func selectDatesBasedOnCGPoints(startPoint : CGPoint, endPoint: CGPoint) {
        generator.prepare()
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
                if selectedDates.count > tempSelectedDates.count {
                    generator.impactOccurred()
                }
                tempSelectedDates = selectedDates
                break
            }
        }
    }

    private func selectDateRange() {
        if !tempSelectedDates.isEmpty {
            modelData.handleSeveralDates(dates: tempSelectedDates)
            tempSelectedDates = []
        }
    }
}

#Preview {
    CalendarPageView()
        .environment(ModelData())
}
