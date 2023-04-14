//
//  ContentView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 14/04/23.
//

import SwiftUI

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView: View {
    struct newLists: Identifiable{
        var id = UUID()
        let name: String
        let Itemtype: String                    //    ["Normal","Private"]
    }
    
    @State private var newlists = [newLists]()
    @State private var _type = "Normal"
    let types = ["Normal","Private"]
    
    @State private var lists: [String] = []
    @State private var newItems = ""
    @State private var isPresented = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isOn = false
    
    let savedPath = FileManager.documentDirectory.appendingPathComponent("SavedItems")
    
    func save(){
        do {
            let data = try JSONEncoder().encode(lists)
            try data.write(to: savedPath, options: [.completeFileProtection])
        }catch{
            print("Unable to save data")
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack{
                    Text("To do list")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    List{
                        ForEach(lists, id: \.self){
                            Text($0)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            isPresented = true
                        }label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.4))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        }
                        .padding([.trailing,.bottom])
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPresented){
                Form {
                    TextField("Enter Items",text: $newItems)
                    Picker("Types", selection: $_type){
                        ForEach(types , id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                if(newItems != ""){
                    Button("save"){
                        lists.append(newItems)
                        save()
                        isPresented.toggle()
                        newItems = ""
                        
                    }
                }
            }
            .onAppear {
                do {
                    let data = try Data(contentsOf: savedPath)
                    lists = try JSONDecoder().decode([String].self, from: data)
                } catch {
                    print("Error loading data: \(error)")
                }
            }
            .toolbar(){
                Menu{
                    Button(colorScheme == .light ? "Light" : "Dark") {
                        if colorScheme == .light {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                        } else {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                        }
                    }
                    Button("Option 2") {
                        // Do something
                    }
                    Button("Option 3") {
                        // Do something
                    }
                }label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                }
            }
        }
    }
    func deleteItems(at offsets: IndexSet) {
            lists.remove(atOffsets: offsets)
            save()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
