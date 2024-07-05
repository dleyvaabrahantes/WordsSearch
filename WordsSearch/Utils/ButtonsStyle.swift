//
//  ButtonsStyle.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import Foundation
import SwiftUI

struct YellowButton: View {
    var body: some View {
        Button {
            
        } label: {
            Text("Start Game")
        }
        .buttonStyle(YellowButtonStyle())
    }
}

#Preview {
    YellowButton()
}

struct YellowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 155, height: configuration.isPressed ? 63 : 67)
                .foregroundStyle(.black)
                .offset(y: configuration.isPressed ? 0.2 : 3)
            configuration.label.bold()
                .offset(y: configuration.isPressed ? -0.5 : 0)
                .foregroundStyle(configuration.isPressed ? .white : .black)
                .frame(width: 150, height: 60)
                .background(configuration.isPressed ? .cyan : .yellow , in: .rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 2)
                        .foregroundStyle(.white)
                }
        }
        .frame(height: 60)
        .animation(.spring, value: configuration.isPressed)
    }
}


struct YellowTextStyle: ViewModifier {

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 155, height: 67)
                .foregroundColor(.black)
                .offset(y: 3)
            content
                .bold()
                .offset(y:  0)
                .foregroundColor(.black)
                .frame(width: 150, height: 60)
                .background(Color.yellow)
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                }
        }
        .frame(height: 60)
        //.animation(.spring(), value: isPressed)
    }
}

extension View {
    func yellowTextStyle() -> some View {
        self.modifier(YellowTextStyle())
    }
}
