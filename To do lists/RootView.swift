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
            NavigationStack{
                settingView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack{
                loginView()
            }
        })
    }
}

#Preview {
    RootView()
}
