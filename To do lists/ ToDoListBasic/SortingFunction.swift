//
//  SortingFunction.swift
//  To do lists
//
//  Created by Harshit Agarwal on 22/09/23.
//

import Foundation

func sortedItems(_ list: [newLists]) -> [(date: Date, lists: [newLists])] {
    let groupedItems = Dictionary(grouping: list){list in
        Calendar.current.startOfDay(for: list.date)
        
    }
    let sortedKeys = groupedItems.keys.sorted(by: >)
    return sortedKeys.map{key in
        (date: key,lists: groupedItems[key]!)
    }
}
