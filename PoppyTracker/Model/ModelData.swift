//
//  ModelData.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import Foundation

@Observable
class ModelData {

    var selectedDates : Set<Date> = []
    var averageCycleLength : Int = 28
    var averagePeriodLength : Int = 7

    private var periods : [Period] = []

    func handleOneDate(date : Date) {
        if selectedDates.contains(date) {
            selectedDates.remove(date)
        } else {
            selectedDates.insert(date)
        }
        refreshStatistics()
    }

    func handleSeveralDates(dates : [Date]) {
        if selectedDates.isSuperset(of: dates) {
            selectedDates.subtract(dates)
        } else {
            selectedDates.formUnion(dates)
        }
        refreshStatistics()
    }

    private func refreshStatistics() {
        periods = []

        let sortedDates : [Date] = selectedDates.sorted(by: { $0 < $1 })

        var subsets: [[Date]] = []
        var currentSubset: [Date] = []

        for (index, date) in sortedDates.enumerated() {
            if currentSubset.isEmpty {
                currentSubset.append(date)
            } else if index < sortedDates.count, areDatesConsecutive(firstDate: currentSubset.last!, secondDate: date) {
                // is consecutive -> we add to current period
                currentSubset.append(date)
            } else {
                // is not consecutive -> we create a new period
                subsets.append(currentSubset)
                currentSubset = [date]
            }
        }

        if !currentSubset.isEmpty {
            subsets.append(currentSubset)
        }

        for subset in subsets {
            periods.append(Period(startDate: subset.first!, endDate: subset.last!))
        }

        computeAverageCycleLength()
        computeAveragePeriodLength()
    }

    private func computeAveragePeriodLength() {
        var intervals = [Int]()

        for i in 1..<periods.count {
            intervals.append(periods[i].dates!.count)
        }

        let sum = intervals.reduce(0, +)
        let average = Double(sum) / Double(intervals.count)
        averagePeriodLength = Int(round(average))

        print("new average period length: \(averagePeriodLength)")
    }

    private func computeAverageCycleLength() {
        var intervals = [Int]()

        for i in 1..<periods.count {
            let previousDate = periods[i - 1].startDate
            let currentDate = periods[i].startDate

            let components = Calendar.current.dateComponents([.day], from: previousDate, to: currentDate)
            if let day = components.day {
                intervals.append(day)
            }
        }

        let sum = intervals.reduce(0, +)
        let average = Double(sum) / Double(intervals.count)
        averageCycleLength = Int(round(average))

        print("new average cycle length: \(averageCycleLength)")
    }

    func setupMockData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var date1 = dateFormatter.date(from: "30/10/2023")
        var date2 = dateFormatter.date(from: "3/11/2023")
        periods.append(Period(startDate: date1!, endDate: date2!))

        date1 = dateFormatter.date(from: "25/11/2023")
        date2 = dateFormatter.date(from: "29/11/2023")
        periods.append(Period(startDate: date1!, endDate: date2!))

        date1 = dateFormatter.date(from: "21/12/2023")
        date2 = dateFormatter.date(from: "24/12/2023")
        periods.append(Period(startDate: date1!, endDate: date2!))

        date1 = dateFormatter.date(from: "18/01/2024")
        date2 = dateFormatter.date(from: "22/01/2024")
        periods.append(Period(startDate: date1!, endDate: date2!))

        date1 = dateFormatter.date(from: "14/02/2024")
        date2 = dateFormatter.date(from: "19/02/2024")
        periods.append(Period(startDate: date1!, endDate: date2!))


        for i in 0..<periods.count {
            selectedDates.formUnion(periods[i].dates!)
        }

        refreshStatistics()

        print("Data setup OK")
    }

}
