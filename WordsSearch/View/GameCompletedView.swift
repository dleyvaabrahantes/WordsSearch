//
//  GameCompletedView.swift
//  WordsSearch
//
//  Created by David on 7/8/24.
//

import SwiftUI

struct GameCompletedView: View {
    var onNext: () -> Void
        var onExit: () -> Void
        var progress = 0.5
        var body: some View {
                VStack(spacing: 20) {
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .padding()

                    Text("You have completed the game. What would you like to do next?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    
//                    ZStack(alignment: .leading){
//                        Rectangle()
//                            .foregroundColor(Color.gray.opacity(0.3))
//                            .frame(width: 300, height: 20)
//                        Rectangle()
//                            .foregroundColor(.green)
//                            .frame(width: CGFloat((progress) * 300 ), height: 20)
//                            .cornerRadius(10)
//                        
//                    }
//                    .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            onExit()
                        }) {
                            Text("Exit")
                                .yellowTextStyle(color: .red, width: 100)
                            //                            .padding()
                            //                            .frame(maxWidth: .infinity)
                            //                            .background(Color.red)
                            //                            .foregroundColor(.white)
                            //                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            onNext()
                        }) {
                            Text("Next")
                                .yellowTextStyle(color: .green, width: 100)
                            //                            .padding()
                            //                            .frame(maxWidth: .infinity)
                            //                            .background(Color.blue)
                            //                            .foregroundColor(.white)
                            //                            .cornerRadius(10)
                        }
                        
                        
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
            .shadow(radius: 10)
            }
        
}

#Preview {
    GameCompletedView(onNext: {}, onExit: {})
}
