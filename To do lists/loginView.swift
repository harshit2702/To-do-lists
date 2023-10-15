//
//  loginView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct GoogleSignInResultModel{
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

@MainActor
final class AuthenticationViewModel: ObservableObject{
    
    func signInGoogle()  async throws{
            // Use optional chaining and provide a default value if it's nil
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
               let gidSigninResult =  try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                
                guard  let idToken: String = gidSigninResult.user.idToken?.tokenString    else{
                    throw URLError(.badServerResponse)
                }
                let accessToken: String = gidSigninResult.user.accessToken.tokenString
                let name = gidSigninResult.user.profile?.name
                let email = gidSigninResult.user.profile?.email
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                try await AuthenticationManager.shared.signInWithGoogle(credential: credential)
                
                
            } else {
                print("Could not obtain a root view controller")
            }
        }
}


struct loginView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
                        
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, state: .pressed)) {
                Task {
                    do{
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    }catch{
                        print("Error: \(error)")
                    }
                }
                
            }
            .frame(height: 55)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack{
        loginView(showSignInView: .constant(false))
    }
}
