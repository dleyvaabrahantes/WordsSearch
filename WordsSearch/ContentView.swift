//
//  ContentView.swift
//  WordsSearch
//
//  Created by David on 7/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: WordSearchViewModel
    @State private var gestureDirection: Direction?
    @State private var startCell: Cell?
    var categoryModel: CategoryModel?
    let rows = 11
    let columns = 8
    // let gridSize = 8
    @State private var timeRemaining = 600 // 10 minutes in seconds
        @State private var showAlert = false
        @State private var timer: Timer? = nil
    let cellSize: CGFloat = 40 // Ajusta este valor para cambiar el tamaño de las celdas
    private let adLoader = InterstitialAdLoader(adUnit: .InterstitialTest)
    @AppStorage("showAd") var showAd = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack {
                //                Text("WordSearch")
                //                    .font(.largeTitle)
                //                    .padding(.top)
                HStack {
                    HStack{
                        Text("\(formattedTime)")
                        
                        Image(systemName: "deskclock")
                    }
                    .opacity(0)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    Capsule()
                        .fill(Color.blue.opacity(0.08))
                        .frame(height: 40)
                        .overlay(
                            Text(viewModel.selectedCells.map { viewModel.grid[$0.row][$0.col] }.joined())
                                .foregroundColor(.white)
                                .font(.headline)
                            // .padding()
                        )
                    //.padding()
                        .opacity(viewModel.selectedCells.isEmpty ? 0 : 1)
                        .animation(.easeInOut)
                    
                    HStack{
                        Text(formattedTime)
                        
                        Image(systemName: "deskclock")
                    }
                    .foregroundColor(.gray)
                    .padding(.trailing)
                }
                
                
                GridView(grid: viewModel.grid, selectedCells: $viewModel.selectedCells, foundCells: $viewModel.foundCells, cellSize: cellSize)
                //  .padding(8) // Adjust padding to align with gesture
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let col = Int((value.location.x - 16) / cellSize)
                                let row = Int((value.location.y - 16) / cellSize)
                                
                                if row >= 0 && row < rows && col >= 0 && col < columns {
                                    let newCell = Cell(row: row, col: col)
                                    
                                    if viewModel.selectedCells.isEmpty {
                                        // Start the selection
                                        startCell = newCell
                                        viewModel.selectedCells.append(newCell)
                                    } else if let startCell = startCell {
                                        let newDirection = determineDirection(from: startCell, to: newCell)
                                        if newDirection != .invalid {
                                            gestureDirection = newDirection
                                            if isValidNextCell(newCell, direction: newDirection) {
                                                viewModel.selectedCells.append(newCell)
                                            } else {
                                                // If direction changes, recalculate the line
                                                viewModel.selectedCells = calculateLine(from: startCell, to: newCell, direction: newDirection)
                                            }
                                        }
                                    }
                                }
                            }
                            .onEnded { _ in
                                viewModel.checkSelection()
                                viewModel.selectedCells.removeAll()
                                gestureDirection = nil
                                startCell = nil
                            }
                    )
                
                HStack {
                    WordsListView(words: viewModel.words, foundWords: viewModel.foundWords)
                    Spacer()
                }
                
                
                Spacer()
               
            }
            .onAppear{
                if let category = categoryModel {
                    viewModel.updateWords(for: category.nameJson)
                    generateGrid()
                    
                }
                if showAd > 2 {
                 //   adLoader.showAd()
                    showAd = 0
                }else {
                    showAd += 1
                }
                startTimer()
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("Time's Up!"), message: Text("The 10 minutes are over."), dismissButton: .default(Text("OK")))
                    }
            .fullScreenCover(isPresented: $viewModel.gameCompleted) {
                            GameCompletedView(onNext: {
                                viewModel.cleanSelected()
                                if let category = categoryModel {
                                    
                                    viewModel.updateWords(for: category.nameJson)
                                    generateGrid()
                                    timeRemaining = 600
                                }
                                viewModel.gameCompleted = false
                               // showGameCompleted = false
                            }, onExit: {
                                viewModel.cleanSelected()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            .onAppear{
                                
                            }
                            .background(BackgroundClearView())
                        }
//            .alert(isPresented: $viewModel.gameCompleted) {
//                Alert(
//                    title: Text("Complete"),
//                    message: Text("Congratulations! You have completed the game. What would you like to do next?"),
//                    primaryButton: .default(Text("Next")) {
//                        // Lógica para iniciar el siguiente juego
//                        viewModel.cleanSelected()
//                        if let category = categoryModel {
//                            viewModel.updateWords(for: category.nameJson)
//                            generateGrid()
//                            timeRemaining = 600
//                            
//                        }
//                        viewModel.gameCompleted = false
//                    },
//                    secondaryButton: .cancel(Text("Exit")) {
//                        viewModel.cleanSelected()
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//                )
//            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            viewModel.cleanSelected()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
        })
        )
    }
    
    var formattedTime: String {
           let minutes = timeRemaining / 60
           let seconds = timeRemaining % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
    func generateGrid() {
            viewModel.grid = Array(repeating: Array(repeating: "", count: columns), count: rows)
            
            // Insertar palabras en la cuadrícula
            for word in viewModel.words {
                if !placeWordInGrid(word) {
                    print("No se pudo colocar la palabra: \(word)")
                    viewModel.words.removeAll{$0 == word}
                }
            }
            
            // Rellenar las celdas restantes con letras aleatorias
            for row in 0..<rows {
                for col in 0..<columns {
                    if viewModel.grid[row][col] == "" {
                        viewModel.grid[row][col] = String(UnicodeScalar(Int.random(in: 65...90))!)
                    }
                }
            }
        }
    
    func startTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    showAlert = true
                }
            }
        }
    
    func calculateLine(from startCell: Cell, to endCell: Cell, direction: Direction) -> [Cell] {
        var cells = [startCell]
        var currentCell = startCell
        
        while currentCell != endCell {
            let nextRow: Int
            let nextCol: Int
            
            switch direction {
            case .horizontal:
                nextRow = currentCell.row
                nextCol = currentCell.col + (endCell.col > startCell.col ? 1 : -1)
            case .vertical:
                nextRow = currentCell.row + (endCell.row > startCell.row ? 1 : -1)
                nextCol = currentCell.col
            case .diagonal:
                nextRow = currentCell.row + (endCell.row > startCell.row ? 1 : -1)
                nextCol = currentCell.col + (endCell.col > startCell.col ? 1 : -1)
            case .invalid:
                return cells
            }
            
            currentCell = Cell(row: nextRow, col: nextCol)
            cells.append(currentCell)
        }
        
        return cells
    }
    
    func determineDirection(from startCell: Cell, to endCell: Cell) -> Direction {
        let rowDifference = abs(startCell.row - endCell.row)
        let colDifference = abs(startCell.col - endCell.col)
        if rowDifference == 0 && colDifference > 0 {
            return .horizontal
        } else if colDifference == 0 && rowDifference > 0 {
            return .vertical
        } else if rowDifference == colDifference {
            return .diagonal
        } else {
            return .invalid
        }
    }
    
    @discardableResult
       func placeWordInGrid(_ word: String) -> Bool {
           var placed = false
           var attempts = 0
           let maxAttempts = 100
           
           while !placed && attempts < maxAttempts {
               let startRow = Int.random(in: 0..<rows)
               let startCol = Int.random(in: 0..<columns)
               let direction = Int.random(in: 0..<4)
               
               if canPlaceWord(word, at: (startRow, startCol), direction: direction) {
                   for (index, char) in word.enumerated() {
                       let (row, col) = getNextPosition(startRow, startCol, direction, index)
                       viewModel.grid[row][col] = String(char)
                   }
                   placed = true
               }
               attempts += 1
           }
           
           return placed
       }
    
    func canPlaceWord(_ word: String, at start: (Int, Int), direction: Int) -> Bool {
        let (startRow, startCol) = start
        
        for (index, char) in word.enumerated() {
            let (row, col) = getNextPosition(startRow, startCol, direction, index)
            
            if row < 0 || row >= rows || col < 0 || col >= columns || (viewModel.grid[row][col] != "" && viewModel.grid[row][col] != String(char)) {
                return false
            }
        }
        return true
    }
    
    func getNextPosition(_ row: Int, _ col: Int, _ direction: Int, _ step: Int) -> (Int, Int) {
        switch direction {
        case 0: return (row + step, col)         // Down
        case 1: return (row, col + step)         // Right
        case 2: return (row + step, col + step)  // Down-Right Diagonal
        case 3: return (row - step, col + step)  // Up-Right Diagonal
        default: return (row, col)
        }
    }
    
    func isValidNextCell(_ newCell: Cell, direction: Direction) -> Bool {
        guard let lastCell = viewModel.selectedCells.last else { return true }
        let rowDelta = newCell.row - lastCell.row
        let colDelta = newCell.col - lastCell.col
        switch direction {
        case .horizontal:
            return rowDelta == 0 && abs(colDelta) == 1
        case .vertical:
            return abs(rowDelta) == 1 && colDelta == 0
        case .diagonal:
            return abs(rowDelta) == 1 && abs(colDelta) == 1
        case .invalid:
            return false
        }
    }
    
    
}

// function for background clear
struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}




#Preview {
    HomeMenu()
}
