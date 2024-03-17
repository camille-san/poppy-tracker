//
//  CalendarDayView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct CalendarDay: View {

    @Environment(ModelData.self) var modelData

    private let calendar = Calendar.current
    var date : DateContainer
    var size : CGFloat
    var rectPosition : ((CGRect) -> Void)?

    var body: some View {
        GeometryReader { geometry in
            Group {
                if date.isFilled {
                    Text("\(date.dayOfMonth!)")
                        .frame(width: size, height: size)
                        .background(
                            modelData.selectedDates.contains(date.date!) ? .red.opacity(0.6) :
                                    .gray.opacity(0.1))
                        .foregroundStyle(.black)
                        .onAppear {
                            self.rectPosition?(geometry.frame(in: .global))
                        }
                } else {
                    Text("")
                        .frame(width: size, height: size)
                        .background(.clear)
                }
            }
            .font(.system(size: 16,
                          weight: .medium))
            .clipShape(Circle())
        }

    }
}

#Preview {
    let date = Calendar.current.date(from : DateComponents(year: 2024, month: 3))
    return Group {
        CalendarDay(date: DateContainer(isFilled: true, date: date), size: 45)
            .environment(ModelData())
        CalendarDay(date: DateContainer(isFilled: false), size: 45)
            .environment(ModelData())
    }
}
