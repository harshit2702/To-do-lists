//
//  To_do_listsApp.swift
//  To do lists
//
//  Created by Harshit Agarwal on 14/04/23.
//
import SwiftUI
import Firebase

@main
struct To_do_listsApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configure Firebase")
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
