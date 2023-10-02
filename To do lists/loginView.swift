//
//  loginView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import SwiftUI

struct loginView: View {
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView()
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
                        
        }
        .padding()
    }
}

#Preview {
    NavigationStack{
        loginView()
    }
}
