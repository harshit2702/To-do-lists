//
//  SignInEmailView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//
import SwiftUI

final class signInEmail: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            print("Enter Valid Email Password")
            return
        }
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print(returnedUserData)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            print("Enter Valid Email Password")
            return
        }
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print(returnedUserData)
    }
    
}

struct SignInEmailView: View {

    @StateObject private var viewModel  =  signInEmail()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            TextField("Email..",text: $viewModel.email)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            
            SecureField("Password...",text: $viewModel.password)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            
            Button{
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                    }catch{
                        
                    }
                    
                }
            }label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Button{
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    }catch{
                        
                    }
                    
                }
            }label: {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Sign In With Email")
        .padding()
        
    }
}

#Preview {
    NavigationStack{
        SignInEmailView(showSignInView: .constant(false))
    }
}
