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
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else{
            print("Enter Valid Email Password")
            return
        }
        
        Task{
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print(returnedUserData)
            } catch {
                // Handle the error, for example, by displaying an error message to the user
                print("Error: \(error)")
            }
        }

        
    }
}

struct SignInEmailView: View {

    @StateObject private var viewModel  =  signInEmail()
    
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
                viewModel.signIn()
            }label: {
                Text("Sign in")
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
        SignInEmailView()
    }
}
