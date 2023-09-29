//
//  addItemView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 22/09/23.
//

import SwiftUI

struct addItemView: View {
    @State private var newItems = ""
    @State private var _isprivate = false
    @State private var selectedTag: newLists.tag = .none
    @State private var date = Date()
    @Binding var newlists: [newLists]
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Enter Items",text: $newItems)
                    
                    Section("Set Date"){
                        DatePicker("Select a Date", selection: $date, displayedComponents: .date)
                    }
                    
                    Section("Tag"){
                        Picker("Select Tag", selection: $selectedTag) {
                            ForEach(newLists.tag.allCases, id: \.self) { tag in
                                Text(tag.rawValue)
                                    .tag(tag) // Assign the tag as the value
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section("Privacy"){
                        Toggle(isOn: $_isprivate){
                            Text("Private item")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }


                }
                if(newItems != ""){
                    Button("save"){
                        let item = newLists(name: newItems, isprivate: _isprivate, date: date, tag: selectedTag)
                        newlists.insert(item, at: newlists.startIndex)
                        save(newlists)
                        newItems = ""
                        _isprivate = false
                        selectedTag = .none
                        isPresented = false
                        
                    }
                }
            }
            .navigationBarTitle("Tasks")
            .onAppear {
                do {
                    let data = try Data(contentsOf: savedPath)
                    newlists = try JSONDecoder().decode([newLists].self, from: data)
                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }
        
    }
}
//
//#Preview {
//    addItemView()
//}
