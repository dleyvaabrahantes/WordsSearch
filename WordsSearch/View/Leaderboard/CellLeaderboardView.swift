//
//  CellLeaderboardView.swift
//  WordsSearch
//
//  Created by David on 7/26/24.
//

import SwiftUI
import GameKit

struct CellLeaderboardView: View {
    let position: Int
    let name: String
    let value: String
    var body: some View {
                HStack {
                    Text("\(position).") // Position identifier
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.primary)
                    // Create a circle with the player's initial
                                    PlayerInitialView(player: name)
                                        .frame(width: 40, height: 40)
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
               
                .padding(.vertical, 8)
               // .background(.red) // Fondo transparente
                
            }
        }

struct PlayerInitialView: View {
    let player: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
            Text(initial(for: player))
                .font(.headline)
                .foregroundColor(.white)
        }
    }
    
    func initial(for name: String) -> String {
        let initials = name.components(separatedBy: " ")
            .compactMap { $0.first }
            .prefix(2) // To handle names with more than two initials
        return initials.map { String($0).uppercased() }.joined()
    }
}

#Preview {
    CellLeaderboardView(position: 0, name: "iosdladev", value: "25 point")
}
