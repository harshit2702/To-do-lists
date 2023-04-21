//
//  new lists.swift
//  To do lists
//
//  Created by Harshit Agarwal on 15/04/23.
//

import Foundation

struct newLists: Identifiable,Encodable, Decodable{
    let id = UUID()
    let name: String
    let isprivate: Bool
    let date: Date
}
