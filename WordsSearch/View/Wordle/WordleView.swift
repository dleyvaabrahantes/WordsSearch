//
//  WordleView.swift
//  WordsSearch
//
//  Created by David on 7/12/24.
//

import SwiftUI

struct WordleView: View {
    @StateObject var storeVM = StoreVM()
    @StateObject var viewModel = WordleViewModel()
    @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    GridViewGame(game: $viewModel.game)
                    Spacer()
                    KeyboardView(game: $viewModel.game, makeGuessAction: viewModel.makeGuess)
                        .padding()
                }
                .padding()
                .onAppear{
                  
                }
            }
            .alert(isPresented: $viewModel.showTips) {
                Alert(title: Text(LocalizedStringKey("tips")),
                      message: Text(String(format: NSLocalizedString("categoryis", comment: ""), viewModel.categoryTips)),
                      dismissButton: .default(Text("OK")))
            }
            .displayConfetti(isActive: $viewModel.showAlert)
            .fullScreenCover(isPresented: $viewModel.showAlert) {
                            GameCompletedView(title: "congratulations" , description: "detailCongratulation", onNext: {
                                viewModel.newGame()
                                viewModel.showAlert = false
                                
                            }, onExit: {
                                viewModel.showAlert = false
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            .background(BackgroundClearView())
                        }
            .fullScreenCover(isPresented: $viewModel.showGameOverAlert) {
                            GameCompletedView(title: "Game Over" , description: "You've used all your attempts. The word was \(viewModel.targetWord).", onNext: {
                                viewModel.newGame()
                                viewModel.showGameOverAlert = false
                                
                            }, onExit: {
                                viewModel.showAlert = false
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            .background(BackgroundClearView())
                        }
            
//            .alert(isPresented: $viewModel.showAlert) {
//                        Alert(title: Text("Congratulations!"),
//                              message: Text("You've guessed the word correctly."),
//                              dismissButton: .default(Text("OK")))
//                    }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.showTips = true
                    }, label: {
                        Image(systemName: "lightbulb.max.fill")
                            .foregroundColor(.yellow)
                    })
                }
            })
        }
}

#Preview {
    WordleView()
}


struct GridViewGame: View {
    @Binding var game: WordleGame
        
        var body: some View {
            VStack(spacing: 10) {
                ForEach(0..<game.maxAttempts, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<game.targetWord.count, id: \.self) { col in
                            Text(String(getLetter(for: row, col: col).character))
                                .frame(width: 50, height: 50)
                                .background(color(for: getLetter(for: row, col: col).state))
                                .cornerRadius(5)
                                .border(Color.black, width: 2)  // Add border here
                        }
                    }
                }
            }
        }
        
        func getLetter(for row: Int, col: Int) -> Letter {
            if row < game.guesses.count {
                return game.guesses[row][col]
            } else if row == game.guesses.count && col < game.currentGuess.count {
                return game.currentGuess[col]
            } else {
                return Letter(character: " ", state: .unknown)
            }
        }
        
        func color(for state: LetterState) -> Color {
            switch state {
            case .correct:
                return Color.green
            case .misplaced:
                return Color.yellow
            case .incorrect:
                return Color.gray
            case .unknown:
                return Color.clear
            }
        }
}
