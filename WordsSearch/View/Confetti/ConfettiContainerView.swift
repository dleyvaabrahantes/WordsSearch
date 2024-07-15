//
//  ConfettiContainerView.swift
//  WordsSearch
//
//  Created by David on 7/11/24.
//

import Foundation
import SwiftUI

struct ConfettiContainerView: View {
    var count: Int = 50
    @State var yPosition: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { _ in
                ConfettiView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: yPosition != 0 ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : yPosition
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            yPosition = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}