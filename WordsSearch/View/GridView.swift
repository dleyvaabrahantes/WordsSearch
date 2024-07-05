//
//  GridView.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import Foundation
import SwiftUI


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
