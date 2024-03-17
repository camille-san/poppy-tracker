//
//  PinkGradientBackground.swift
//  PoppyTracker
//
//  Created by Camille on 17/3/24.
//

import SwiftUI

struct PinkGradientBackground: View {
    var body: some View {
        LinearGradient(colors: [
            Color.red.opacity(0.1),
            Color.red.opacity(0.3)
        ], startPoint: .bottomTrailing, endPoint: .topLeading)
        .ignoresSafeArea()
    }
}

#Preview {
    PinkGradientBackground()
}
