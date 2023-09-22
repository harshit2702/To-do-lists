//
//  new lists.swift
//  To do lists
//
//  Created by Harshit Agarwal on 15/04/23.
//

import Foundation


struct newLists: Identifiable, Encodable, Decodable{
    var id = UUID()
    let name: String
    let isprivate: Bool
    let date: Date
    var tag: tag
    
    enum tag: String, CaseIterable,Codable{
        case red,orange,yellow,green,blue,purple,grey,none
        
        var color: String {
                    switch self {
                        case .red: return "red"
                        case .orange: return "orange"
                        case .yellow: return "yellow"
                        case .green: return "green"
                        case .blue: return "blue"
                        case .purple: return "purple"
                        case .grey: return "grey"
                        case .none: return "none"
                    }
                }
        
    }
}

let savedPath = FileManager.documentDirectory.appendingPathComponent("SavedItems")



func save(_ list: [newLists]){
    do {
        let data = try JSONEncoder().encode(list)
        try data.write(to: savedPath, options: [.completeFileProtection,.atomic])
    }catch{
        print("Unable to save data")
    }
}

