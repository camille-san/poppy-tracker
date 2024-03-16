//
//  CalendarDayView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct CalendarDayView: View {
    
    @Environment(ModelData.self) var modelData
    
    @State private var scale: CGFloat = 1.0
    
    private let calendar = Calendar.current
    private let size : CGFloat = 45
    var date : DateContainer
    
    func onClickDate() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        withAnimation(.easeInOut(duration: 0.2)) {
            self.scale = 1.25
        }
        withAnimation(.easeInOut(duration: 0.2).delay(0.2)) {
            self.scale = 1.0
        }
        
        let unwrappedDate : Date = date.date!
        if modelData.selectedDates.contains(unwrappedDate) {
            for i in 0..<modelData.selectedDates.count {
                if modelData.selectedDates[i] == unwrappedDate {
                    modelData.selectedDates.remove(at: i)
                    break
                }
            }
        } else {
            modelData.selectedDates.append(unwrappedDate)
        }
        generator.impactOccurred()
    }
    
    var body: some View {
        Group {
            if date.isFilled {
                Button {
                    onClickDate()
                } label: {
                    Text("\(date.dayOfMonth!)")
                        .frame(width: size, height: size)
                        .background(
                            modelData.selectedDates.contains(date.date!) ? .red.opacity(0.6) :
                                    .gray.opacity(0.1))
                        .foregroundStyle(.black)
                        .scaleEffect(scale)
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

#Preview {
    let date = Calendar.current.date(from : DateComponents(year: 2024, month: 3))
    return Group {
        CalendarDayView(date: DateContainer(isFilled: true, date: date))
            .environment(ModelData())
        CalendarDayView(date: DateContainer(isFilled: false))
            .environment(ModelData())
    }
}
