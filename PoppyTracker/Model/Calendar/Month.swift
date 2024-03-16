//
//  Month.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import Foundation

enum Month: Int, CaseIterable {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12

    var monthIndex: Int {
        return self.rawValue
    }

    init?(monthIndex: Int) {
        self.init(rawValue: monthIndex)
    }
}
