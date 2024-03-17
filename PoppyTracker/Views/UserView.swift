//
//  UserView.swift
//  PoppyTracker
//
//  Created by Camille on 16/3/24.
//

import SwiftUI

struct UserView: View {

    @Environment(ModelData.self) var modelData

    var body: some View {
        VStack {
            Text("Statistics")
                .font(.title)
                .bold()
                .padding(.top, 24)
            Group {
                HStack {
                    Text("Average cycle length")
                        .bold()
                    Spacer()
                    Text("\(modelData.averageCycleLength)")
                }
                HStack {
                    Text("Average period length")
                        .bold()
                    Spacer()
                    Text("\(modelData.averagePeriodLength)")
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
        }
        .padding()
        .background(PinkGradientBackground())
    }
}

#Preview {
    UserView()
        .environment(ModelData())
}
