//
//  ListViewByDate.swift
//  To do lists
//
//  Created by Harshit Agarwal on 22/09/23.
//

import SwiftUI

struct ListViewByDate: View {
    @Binding var newlists: [newLists]
    @Binding var isUnlocked: Bool
    
    var body: some View {
        List{
            ForEach(sortedItems(newlists), id: \.date){ section in
                Section(header: Text(section.date, style: .date)){
                    ForEach(section.lists){ list in
                        if(isUnlocked || !list.isprivate) {
                            HStack {
                                VStack {
                                    Text(list.name)
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
        }
    }
    func deleteItems(at offsets: IndexSet) {
        newlists.remove(atOffsets: offsets)
        save(newlists)
        }
}

//#Preview {
//    ListViewByDate()
//}
