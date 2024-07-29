//
//  LeaderboardView.swift
//  WordsSearch
//
//  Created by David on 7/26/24.
//

import SwiftUI
import GameKit

struct LeaderboardView: View {
    @State private var leaderboardEntries: [GKLeaderboard.Entry] = []
    let localPlayerID = GKLocalPlayer.local.gamePlayerID
    
    var body: some View {
        VStack {
            if !leaderboardEntries.isEmpty {
                List(Array(leaderboardEntries.enumerated()), id: \.element.player.gamePlayerID) { index, entry in
                CellLeaderboardView(position: index, name: entry.player.displayName, value: entry.formattedScore)
                    .listRowBackground(entry.player.gamePlayerID == localPlayerID ? Color.yellow.opacity(0.3) : Color.clear)
                    }
                   
              
            } else {
           //     VStack(spacing: 20) {
                    ProgressView()
//                    Button {
//                        authenticatePlayer()
//                    } label: {
//                        Text("Register")
//                            .yellowTextStyle()
//                    }

            //    }
            }
        }
        .task {
            
            do {
                leaderboardEntries = try await fetchLeaderboard()
            } catch {
                print("Failed to fetch leaderboard: \(error)")
            }
        }
        .onAppear{
           // authenticatePlayer()
        }
        .navigationTitle("Leaderboard")
           }

    func fetchLeaderboard() async throws -> [GKLeaderboard.Entry] {
        let leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: ["com.word.leaderboards"]).first
        let entriesTuple = try await leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10))
        return entriesTuple?.1 ?? []
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Show the login view controller
               // self.present(viewController, animated: true)
            } else if error != nil {
                // Handle the error
                print(error?.localizedDescription ?? "")
            } else {
                // Player is already authenticated
                print("Authenticated as \(GKLocalPlayer.local.displayName)")
            }
        }
    }
}

#Preview {
    LeaderboardView()
}

