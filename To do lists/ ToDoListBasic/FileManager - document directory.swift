//
//  FileManager - document directory.swift
//  To do lists
//
//  Created by Harshit Agarwal on 15/04/23.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
