//
//  SettingView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import SwiftUI

@MainActor
final class settingViewModel: ObservableObject{
    
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
}

struct settingView: View {
    @StateObject private var viewModel = settingViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Log Out"){
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    }catch{
                        
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack{
        settingView(showSignInView: .constant(false))
    }
}
