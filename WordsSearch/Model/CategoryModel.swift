//
//  CategoryModel.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import Foundation


struct CategoryModel: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let level: Dificulty
    let nameJson: String
}

enum Dificulty: Int {
    case easy,medium,hard
    
    
    var level: String {
        switch self {
            
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}


struct WordCategory: Codable {
    let category: String
    let words: [String]
}
