//
//  SettingView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import SwiftUI

@MainActor
final class settingViewModel: ObservableObject{
    
    @Published var authProvider: [AuthProviderOption] = []
    @Published var user: AuthDataResultModel?
    
    func loadAuthProvider(){
        if let providers = try? AuthenticationManager.shared.getProviders(){
            authProvider = providers
        }
        
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser(){
            self.user = user
        }
    }
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    func updatePassword() async throws {
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct settingView: View {
    @StateObject private var viewModel = settingViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            
            if let user = viewModel.user {
                Text("Email: \(user.email ?? "Not available")")
                if viewModel.authProvider.contains(.google){
                    Text("Name: \(user.displayName ?? "Not available")")
                }


            }
            
            Button("Log Out"){
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    }catch{
                        print("Error: \(error)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task{
                    do{
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    }catch{
                        print("Error: \(error)")
                    }
                }
            } label: {
                Text("Delete Account")
            }
            
            if viewModel.authProvider.contains(.email){
                
                Button("Reset Password"){
                    Task{
                        do{
                            try await viewModel.resetPassword()
                            print("Password Reset")
                        }catch{
                            print("Error: \(error)")
                        }
                    }
                }
                Button("Update Email"){
                    Task{
                        do{
                            try await viewModel.updateEmail()
                            print("Email Update")
                        }catch{
                            print("Error: \(error)")
                        }
                    }
                }
                Button("Update Password"){
                    Task{
                        do{
                            try await viewModel.updatePassword()
                            print("Password Update")
                        }catch{
                            print("Error: \(error)")
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Settings")
        .onAppear{
            viewModel.loadAuthProvider()
        }
    }
}

#Preview {
    NavigationStack{
        settingView(showSignInView: .constant(false))
    }
}
