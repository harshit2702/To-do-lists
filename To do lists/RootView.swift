//
//  RootView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            if !showSignInView{
                NavigationStack{
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack{
                loginView(showSignInView: $showSignInView)
            }
        })
    }
}

#Preview {
    RootView()
}
