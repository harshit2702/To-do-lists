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
    @State private var newlists = [newLists]()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Enter Items",text: $newItems)
                    
                    Section("Privacy"){
                        Toggle(isOn: $_isprivate){
                            Text("Private item")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    
                    Section("Tag"){
                        Picker("Select Tag", selection: $selectedTag) {
                            ForEach(newLists.tag.allCases, id: \.self) { tag in
                                HStack(alignment: .center){
                                    if tag != newLists.tag.none {
                                        Circle()
                                            .fill(Color(tag.rawValue))
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
                                    Text(tag.rawValue)
                                        .tag(tag) // Assign the tag as the value
                                }
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }

                }
                if(newItems != ""){
                    Button("save"){
                        let item = newLists(name: newItems, isprivate: _isprivate, date: Date(), tag: selectedTag)
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
