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
    var averagePeriodLength : Int = 5

    var periods : [Period] = []

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
        let calendar = Calendar.current

        var dates = [Date]()
        dates.append(Date())
        dates.append(calendar.date(byAdding: .day, value: 5, to: Date())!)
        dates.append(calendar.date(byAdding: .day, value: 11, to: Date())!)
        dates.append(calendar.date(byAdding: .day, value: 20, to: Date())!)
        dates.append(calendar.date(byAdding: .day, value: 27, to: Date())!)
        dates.append(calendar.date(byAdding: .day, value: 35, to: Date())!)

        var endDates = [Date]()
        endDates.append(Date())
        endDates.append(calendar.date(byAdding: .day, value: 11, to: Date())!)
        endDates.append(calendar.date(byAdding: .day, value: 20, to: Date())!)
        endDates.append(calendar.date(byAdding: .day, value: 25, to: Date())!)
        endDates.append(calendar.date(byAdding: .day, value: 32, to: Date())!)
        endDates.append(calendar.date(byAdding: .day, value: 45, to: Date())!)

        periods = [Period]()
        for i in 0..<dates.count {
            periods.append(Period(startDate: dates[i], endDate: endDates[i]))
        }

        computeAverageCycleLength(periods: periods)
        computeAveragePeriodLength(periods: periods)
    }

    private func computeAveragePeriodLength(periods : [Period]) {
        var intervals = [Int]()

        for i in 1..<periods.count {
            intervals.append(periods[i].dates!.count)
        }

        let sum = intervals.reduce(0, +)
        let average = Double(sum) / Double(intervals.count)
        averagePeriodLength = Int(ceil(average))

        print("new average period length: \(averagePeriodLength)")
    }

    private func computeAverageCycleLength(periods : [Period]) {
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
        averageCycleLength = Int(ceil(average))

        print("new average cycle length: \(averageCycleLength)")
    }

}
