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
    @State private var filteredItemList = [newLists]()
    @State private var isPresented = false

    @State private var showingAlert = false
    
    @State private var isUnlocked = false
    
    @State private var presentEditView = false
    
    @AppStorage("sortDate") var isSortByDate = false
    @State private var selectedSortTag: newLists.tag? = nil
        
    @AppStorage("theme") var theme: AppTheme = .light
        
    var body: some View {
        NavigationStack{
            ZStack {
                if(!isSortByDate){
                    withAnimation{
                        ListView(newlists: $newlists, filteredItems: $filteredItemList, isUnlocked: $isUnlocked, presentEditView: $presentEditView)

                    }
                }else{
                    ListViewByDate(newlists: $newlists, isUnlocked: $isUnlocked)
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
            .sheet(isPresented: $isPresented){
                addItemView(newlists: $newlists, isPresented: $isPresented)
            }
            .onTapGesture{
                isPresented = true
            }
            .onAppear {
                do {
                    let data = try Data(contentsOf: savedPath)
                    newlists = try JSONDecoder().decode([newLists].self, from: data)
                    filteredItemList = newlists
                } catch {
                    print("Error loading data: \(error)")
                }
            }
            .onChange(of: isSortByDate){ _ in
                do {
                    let data = try Data(contentsOf: savedPath)
                    newlists = try JSONDecoder().decode([newLists].self, from: data)
                    filteredItemList = newlists
                } catch {
                    print("Error loading data: \(error)")
                }
            }
            .onChange(of: selectedSortTag) { _ in
                filteredItemList = newlists
                sortTasks()
            }
            .onChange(of: presentEditView) { _ in
                filteredItemList = newlists
                sortTasks()
            }
            .onChange(of: isPresented) { _ in
                filteredItemList = newlists
                sortTasks()
            }
            .toolbar(){
                Menu{
                    Button{
                        if theme == .light {
                            theme = .dark
                        } else {
                            theme = .light
                        }
                    }label: {
                        if(theme == .light) {
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
                            if tag.rawValue != "none" {
                                Button{
                                    selectedSortTag = tag
                                }label: {
                                    HStack{
                                        Text("\(tag.rawValue)")
                                        if(selectedSortTag == tag){
                                            Image(systemName: "checkmark" )
                                        }
                                    }
                                }
                            }
                        }
                        Button{
                            selectedSortTag = nil
                            filteredItemList = newlists
                        }label:{
                            HStack {
                                Text("All")
                                if(selectedSortTag == nil){
                                    Image(systemName: "checkmark" )
                                }
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
                    NavigationLink{
                        RootView()
                    } label: {
                        HStack{
                            Text("Connect")
                            Image(systemName: "gear")
                                .font(.headline)
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
        .preferredColorScheme(theme.colorScheme)
    }
    func delete(){
        withAnimation {
            newlists.removeAll()
        }
        save(newlists)
        filteredItemList = newlists
    }

    func sortTasks() {
        if selectedSortTag != nil{
            if let selectedSortTag = selectedSortTag {
                filteredItemList = newlists.filter { $0.tag == selectedSortTag }
            }
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
