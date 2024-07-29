//
//  HeaderBoard.swift
//  WordsSearch
//
//  Created by David on 7/26/24.
//

import SwiftUI
import GameKit

struct HeaderBoard: View {
    @State private var leaderboardEntries: [GKLeaderboard.Entry] = []
    let localPlayerID = GKLocalPlayer.local.gamePlayerID
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                        // .fontWeight(.bold)
                    }
                    .foregroundColor(.primary)
                    
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                if !leaderboardEntries.isEmpty {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                        .padding(.horizontal)
                        .padding(.leading)
                        .padding(5)
                    HStack(alignment: .bottom) {
                                        Circleheader(index: 2, color: Color(uiColor: .color2), width: 80, height: 80, name: leaderboardEntries.count > 1 ? leaderboardEntries[1].player.displayName : "")
                                        Spacer()
                                        Circleheader(index: 1, color: Color(uiColor: .color4), width: 120, height: 120, name: leaderboardEntries.count > 0 ? leaderboardEntries[0].player.displayName : "")
                                        Spacer()
                                        Circleheader(index: 3, color: Color(uiColor: .colorPink), width: 80, height: 80, name: leaderboardEntries.count > 2 ? leaderboardEntries[2].player.displayName : "")
                                    }
                    .padding([.bottom,.horizontal])
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.purple,
                                                                             Color.purple.opacity(0.8),Color.purple.opacity(0.5),
                                                                             Color.blue.opacity(0.2),
                                                                             Color.green.opacity(0.8)]),
                                                 startPoint: .topLeading,
                                                 endPoint: .bottomTrailing))
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        HStack() {
                            Text("You Currently Rank")
                                .foregroundStyle(.primary)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                            if let index = leaderboardEntries.firstIndex(where: { $0.player.gamePlayerID == localPlayerID }) {
                                Text("\(index + 1)")
                                    .foregroundStyle(.primary)
                                    .fontWeight(.bold)
                                    .padding(.trailing)
                            } else {
                                Text("N/A") // O cualquier otro texto que desees mostrar si no se encuentra el jugador
                                    .foregroundStyle(.primary)
                                    .fontWeight(.bold)
                                    .padding(.trailing)
                            }
                        }
                        
                        .padding(.horizontal,20)
                    }
                    .shadow(radius: 1)
                    
                    List{
                        ForEach(0..<leaderboardEntries.count, id: \.self) { item in
                            CellLeaderboardView(position: item + 1, name: leaderboardEntries[item].player.displayName, value: "\(leaderboardEntries[item].score)")
                        }
                        .listRowBackground(Color.clear)
                    }.scrollContentBackground(.hidden)
                        .listSectionSeparator(.hidden)
                    Spacer()
                    
                } else {
                    ProgressView()
                    Spacer()
                }
            }
        }
        .task {
            
            do {
                leaderboardEntries = try await fetchLeaderboard()
            } catch {
                print("Failed to fetch leaderboard: \(error)")
            }
        }
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
    HeaderBoard()
}


struct Circleheader: View {
    let index: Int
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let name: String
    var body: some View {
        VStack(spacing: 20) {
                    ZStack(alignment: .bottom) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: width, height: height)
                                .overlay(
                                    Circle().stroke(color, lineWidth: 2)
                                )
                                .shadow(color: color, radius: 2)
                            
                            // Inicial del nombre en el centro
                            if let initial = name.first {
                                Text(String(initial))
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            } else {
                                Text("?")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Posición en la parte inferior del círculo
                        Text("\(index)")
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(color)
                            }
                            .shadow(color: color, radius: 2)
                            .offset(x: 4, y: 15)
                    }
                    Text(name.isEmpty ? "Empty" : name)
                        .foregroundStyle(name.isEmpty ? .secondary : .primary)
                }
            }
}
