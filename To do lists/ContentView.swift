//
//  ContentView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 14/04/23.
//

import SwiftUI
import LocalAuthentication

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView: View {
    struct newLists: Identifiable,Encodable, Decodable{
        var id = UUID()
        let name: String
        let Itemtype: String                    //    ["Normal","Private"]
    }
    
    @State private var newlists = [newLists]()
    @State private var _type = "Normal"
    let types = ["Normal","Private"]
    @State private var newItems = ""
    @State private var isPresented = false
    
    
    @State private var showingAlert = false
    
    @State private var isUnlocked = false
    
    @Environment(\.colorScheme) var colorScheme
        
    let savedPath = FileManager.documentDirectory.appendingPathComponent("SavedItems")
    
    func save(){
        do {
            let data = try JSONEncoder().encode(newlists)
            try data.write(to: savedPath, options: [.completeFileProtection,.atomic])
        }catch{
            print("Unable to save data")
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                    List{
                        ForEach(newlists){ list in
                            HStack {
                                Text(list.name)
                                    .font(.title)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(list.Itemtype)
                                    .fontWeight(.bold)
                            }
                        }
                        .onDelete(perform: deleteItems)
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
            .navigationTitle("To do list")
            .navigationBarTitleDisplayMode(.automatic)
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
                        let item = newLists(name: newItems, Itemtype: _type)
                        newlists.append(item)
                        save()
                        isPresented.toggle()
                        newItems = ""
                        
                    }
                }
            }
            .onAppear {
                do {
                    let data = try Data(contentsOf: savedPath)
                    newlists = try JSONDecoder().decode([newLists].self, from: data)
                } catch {
                    print("Error loading data: \(error)")
                }
            }
            .toolbar(){
                Menu{
                    Button{
                        if colorScheme == .light {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                        } else {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                        }
                    }label: {
                        if(colorScheme == .light) {
                            HStack{
                                Text("Light" )
                                Image(systemName: "sun.max.circle")
                            }
                        } else{
                            HStack{
                                Text("Dark")
                                Image(systemName: "moon.circle")
                            }
                        }
                    }
                    Button("Delete", action: {showingAlert = true})
                    Button{
                        authenticate()
                    }label:{
                        isUnlocked ? Text("Unlocked") : Text("Locked")
                    }
                }label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Confirm Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .destructive(Text("Delete"), action: delete), secondaryButton: .cancel())
                }
            }
        }
    }
    func deleteItems(at offsets: IndexSet) {
            newlists.remove(atOffsets: offsets)
            save()
        }
    func delete(){
        newlists.removeAll()
        save()
    }
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "We need to unlock Private Item List"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){success , authenticatioError in
                if success{
                    isUnlocked = true
                }else{
                    
                }
            }
        }
        else{
            //No biometrics
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
