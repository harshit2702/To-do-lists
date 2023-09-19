//
//  ContentView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 14/04/23.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {

    @State private var newlists = [newLists]()
    @State private var newItems = ""
    @State private var _isprivate = false
    @State private var isPresented = false
    @State private var selectedTag: newLists.tag = .none

    @State private var showingAlert = false
    
    @State private var isUnlocked = false
    
    @State private var isSortByDate = false
    @State private var selectedSortTag: newLists.tag? = nil
    
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
        NavigationStack{
            ZStack {
                if(!isSortByDate){
                    List{
                        ForEach(newlists) { list in
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
                    .onTapGesture{
                        isPresented = true
                    }

                }else{
                    List{
                        ForEach(sortedItems(), id: \.date){ section in
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
                        }.listStyle(GroupedListStyle())
                    }
                    .onTapGesture{
                        isPresented = true
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
            .navigationTitle("To do list")
            .navigationBarTitleDisplayMode(.automatic)
            .sheet(isPresented: $isPresented){
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
                                save()
                                isPresented.toggle()
                                newItems = ""
                                _isprivate = false
                                selectedTag = .none
                                
                            }
                        }
                    }
                    .navigationBarTitle("Tasks")
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
                    Button{
                        authenticate()
                    }label:{
                        isUnlocked ? HStack {
                            Text("Unlocked")
                            Image(systemName: "lock.open")
                        } : HStack {
                            Text("Locked")
                            Image(systemName: "lock.fill")
                        }
                    }
                    Button{
                        isSortByDate.toggle()
                    }label: {
                        HStack {
                            Text("Sort by date")
                            if(isSortByDate){
                                Image(systemName: "checkmark" )
                            }
                        }
                    }
                    Menu{
                        ForEach(newLists.tag.allCases, id: \.self) { tag in
                            Button("\(tag.rawValue)"){
                                selectedSortTag = tag
                            }
                        }
                    }label:{
                        Text("Sort By Tag")
                    }
                    Button{
                        showingAlert = true
                    }label:{
                        HStack {
                            Text("Delete")
                            Image(systemName: "multiply.circle")
                        }
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
    func sortedItems() -> [(date: Date, lists: [newLists])] {
        let groupedItems = Dictionary(grouping: newlists){list in
            Calendar.current.startOfDay(for: list.date)
            
        }
        let sortedKeys = groupedItems.keys.sorted(by: >)
        return sortedKeys.map{key in
            (date: key,lists: groupedItems[key]!)
        }
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
