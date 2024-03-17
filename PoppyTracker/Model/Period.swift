//
//  Period.swift
//  PoppyTracker
//
//  Created by Camille on 17/3/24.
//

import Foundation

struct Period {

    var startDate : Date
    var endDate : Date
    var dates : [Date]?

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        dates = datesBetween(startDate: startDate, endDate: endDate)
    }

}
