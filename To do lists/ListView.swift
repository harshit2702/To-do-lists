//
//  ListView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 22/09/23.
//

import SwiftUI

struct ListView: View {
    @Binding var newlists: [newLists]
    @Binding var filteredItems: [newLists]
    
    @Binding var isUnlocked: Bool
    
    var body: some View {
        List{
            ForEach(filteredItems) { list in
                if(isUnlocked || !list.isprivate) {
                    HStack {
                        if list.tag != newLists.tag.none {
                            Circle()
                                .fill(Color(list.tag.rawValue))
                                .frame(width: 20, height: 20)
                                }
                        else{
                            ZStack{
                                Circle()
                                    .frame(width: 20.0)
                                    .foregroundColor(.black)
                                Circle()
                                    .frame(width: 17.0)
                                    .foregroundColor(.white)
                            }
                        }
                        
            
                        VStack(alignment: .leading) {
                            Text(list.name)
                                .font(.title)
                                .fontWeight(.medium)
                            
                            Text(list.date.formatted(.dateTime
                                .month(.abbreviated)
                                .day(.twoDigits)))
                            .multilineTextAlignment(.leading)
                            
                        }
                        Spacer()
                        if(list.isprivate){
                            Text("Private")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets{
            let item = filteredItems[offset]
            if let index = newlists.firstIndex(where: {$0.id == item.id}){
                newlists.remove(at: index)
                filteredItems.remove(at: offset)
            }
            save(newlists)
        }
    }
}
