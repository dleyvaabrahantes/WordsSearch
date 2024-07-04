//
//  ContentView.swift
//  WordsSearch
//
//  Created by David on 7/3/24.
//

import SwiftUI

struct ContentView: View {
    let words = ["MARY", "UI", "APPLE", "CODE", "DOG", "FOOD", "CAT"]
    @State private var grid: [[String]] = []
    @State private var foundWords: Set<String> = []
    @State private var selectedCells: [Cell] = []
    @State private var foundCells: Set<Cell> = []
    @State private var gestureDirection: Direction?
    @State private var startCell: Cell?

    let gridSize = 8
    let cellSize: CGFloat = 40 // Ajusta este valor para cambiar el tamaño de las celdas

    var body: some View {
        VStack {
            Text("WordSearch")
                .font(.largeTitle)
                .padding(.top)
            
            GridView(grid: grid, selectedCells: $selectedCells, foundCells: $foundCells, cellSize: cellSize)
              //  .padding(8) // Adjust padding to align with gesture
                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let col = Int((value.location.x - 16) / cellSize)
                                            let row = Int((value.location.y - 16) / cellSize)
                                            
                                            if row >= 0 && row < gridSize && col >= 0 && col < gridSize {
                                                let newCell = Cell(row: row, col: col)
                                                
                                                if selectedCells.isEmpty {
                                                    // Start the selection
                                                    startCell = newCell
                                                    selectedCells.append(newCell)
                                                } else if let startCell = startCell {
                                                    let newDirection = determineDirection(from: startCell, to: newCell)
                                                    if newDirection != .invalid {
                                                        gestureDirection = newDirection
                                                        if isValidNextCell(newCell, direction: newDirection) {
                                                            selectedCells.append(newCell)
                                                        } else {
                                                            // If direction changes, recalculate the line
                                                            selectedCells = calculateLine(from: startCell, to: newCell, direction: newDirection)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            checkSelection()
                                            selectedCells.removeAll()
                                            gestureDirection = nil
                                            startCell = nil
                                        }
                                )

            HStack {
                WordsListView(words: words, foundWords: foundWords)
                Spacer()
            }

            Spacer()
        }
        .onAppear(perform: generateGrid)
    }

    func generateGrid() {
        grid = Array(repeating: Array(repeating: "", count: gridSize), count: gridSize)

        // Insert words into grid
        for word in words {
            placeWordInGrid(word)
        }

        // Fill the remaining cells with random letters
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == "" {
                    grid[row][col] = String(UnicodeScalar(Int.random(in: 65...90))!)
                }
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

    enum Direction {
        case horizontal, vertical, diagonal, invalid
    }

    func placeWordInGrid(_ word: String) {
        var placed = false
        while !placed {
            let startRow = Int.random(in: 0..<gridSize)
            let startCol = Int.random(in: 0..<gridSize)
            let direction = Int.random(in: 0..<4)

            if canPlaceWord(word, at: (startRow, startCol), direction: direction) {
                for (index, char) in word.enumerated() {
                    let (row, col) = getNextPosition(startRow, startCol, direction, index)
                    grid[row][col] = String(char)
                }
                placed = true
            }
        }
    }

    func canPlaceWord(_ word: String, at start: (Int, Int), direction: Int) -> Bool {
        let (startRow, startCol) = start

        for (index, char) in word.enumerated() {
            let (row, col) = getNextPosition(startRow, startCol, direction, index)

            if row < 0 || row >= gridSize || col < 0 || col >= gridSize || (grid[row][col] != "" && grid[row][col] != String(char)) {
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
        guard let lastCell = selectedCells.last else { return true }
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

    func checkSelection() {
        let selectedWord = selectedCells.map { grid[$0.row][$0.col] }.joined()
        if words.contains(selectedWord) {
            foundWords.insert(selectedWord)
            foundCells.formUnion(selectedCells)
        }
    }
}

struct GridView: View {
    let grid: [[String]]
    @Binding var selectedCells: [Cell]
    @Binding var foundCells: Set<Cell>
    let cellSize: CGFloat

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<self.grid[row].count, id: \.self) { col in
                        Text(self.grid[row][col])
                            .frame(width: cellSize, height: cellSize)
                            .font(.system(size: cellSize * 0.5))
                            .background(self.foundCells.contains(Cell(row: row, col: col)) ? Color.green : (self.selectedCells.contains(Cell(row: row, col: col)) ? Color.yellow : Color.gray))
                            .cornerRadius(4)
                            //.padding(2)
                    }
                }
            }
        }
    }
}

struct WordsListView: View {
    let words: [String]
    let foundWords: Set<String>

    var body: some View {
        VStack(alignment: .leading) {
            Text("Palabras a encontrar:")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(words, id: \.self) { word in
                Text(word)
                    .foregroundColor(self.foundWords.contains(word) ? .green : .primary)
            }
        }
        .padding()
    }
}

struct Cell: Hashable {
    let row: Int
    let col: Int
}

#Preview {
    ContentView()
}
