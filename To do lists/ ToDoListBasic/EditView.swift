//
//  EditView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 29/09/23.
//

import SwiftUI

struct EditView: View {
    @Binding var item: newLists
    @Binding var newlists: [newLists]
    
    @Binding var presentEditView: Bool


    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section(header: Text("Edit Item")) {
                        
                        TextField("Enter Items", text: $item.name)
                        
                        DatePicker("Select a Date", selection: $item.date, displayedComponents: .date)
                        
                        Picker("Select Tag", selection: $item.tag) {
                            ForEach(newLists.tag.allCases, id: \.self) { tag in
                                Text(tag.rawValue).tag(tag)
                            }
                        }
                        
                        Toggle(isOn: $item.isprivate) {
                            Text("Private item")
                        }
                    }
                }
                if(item.name != ""){
                    Button("save"){
                        if let index = newlists.firstIndex(where: {$0.id == item.id}){
                            newlists[index].name = item.name
                            newlists[index].isprivate = item.isprivate
                            newlists[index].tag = item.tag
                            
                            save(newlists)
                            presentEditView = false
                        }
                    }
                }
            }
            .navigationTitle("Edit View")
        }
    }
}


//#Preview {
//    EditView(newItems: <#String#>, _isprivate: <#Bool#>, selectedTag: <#newLists.tag#>, date: <#Date#>)
//}
