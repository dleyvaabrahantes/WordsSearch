//
//  GameCompletedView.swift
//  WordsSearch
//
//  Created by David on 7/8/24.
//

import SwiftUI

struct GameCompletedView: View {
    @AppStorage("premiumUser") var premiumUser: Bool = false
    var title: String
    var description: String
    
    var onNext: () -> Void
        var onExit: () -> Void
     
    @AppStorage("totalGame") private var totalGameToday: Int = 0
    @AppStorage("storedDate") private var storedDateString: String = ""
  //  @State var exceededLimit: Bool = false
        @State private var isSameDay: Bool = false
   
   
        private let maxGamesPerDay = 3
        @State private var progress: CGFloat = 0.0
        
        private var computedProgress: CGFloat {
            return CGFloat(totalGameToday) / CGFloat(maxGamesPerDay)
        }
    
        var body: some View {
                VStack(spacing: 20) {
                    Text(LocalizedStringKey(title))
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.black)

                    Text(LocalizedStringKey(description))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(.black)
                    if !premiumUser {
                        ZStack(alignment: .leading) {
                                        Rectangle()
                                            .foregroundColor(Color.gray.opacity(0.3))
                                            .frame(width: 300, height: 20)
                                        Rectangle()
                                            .foregroundColor(.green)
                                            .frame(width: progress * 300, height: 20)
                                            .cornerRadius(10)
                                    }
                                    .cornerRadius(10)
                        Text("\(totalGameToday) of \(maxGamesPerDay) daily games completed")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                    }
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            onExit()
                        }) {
                            Text(LocalizedStringKey("exit"))
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
                            Text(LocalizedStringKey("next"))
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
            .onAppear {
                    handleDateCheck()
                progress = computedProgress
                   }
            }
    
    private func handleDateCheck() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: currentDate)

        if storedDateString.isEmpty {
            // No hay fecha almacenada, guardar la fecha actual
            storedDateString = currentDateString
            // Revisar conteo del mismo dia
        } else {
            // Hay una fecha almacenada, compararla con la fecha actual
            if let storedDate = dateFormatter.date(from: storedDateString) {
                if storedDateString == currentDateString {
                    storedDateString = currentDateString
                    
                    if totalGameToday >= 3 {
                  //      exceededLimit = true
                    }else{
                        totalGameToday += 1
                    //    exceededLimit = false
                    }
                    print("Mismo Dia -> \(totalGameToday)")
                }else{
                    totalGameToday = 0
                    storedDateString = currentDateString
                    print("Otro Dia -> \(totalGameToday)")
                }
            } else {
                storedDateString = currentDateString
                isSameDay = false
            }
        }
    }
}

#Preview {
    GameCompletedView(title: "Congratulations!", description: "You have completed the game. What would you like to do next?", onNext: {}, onExit: {})
}
