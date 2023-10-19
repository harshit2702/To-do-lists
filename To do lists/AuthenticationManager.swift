//
//  AuthenticationManager.swift
//  To do lists
//
//  Created by Harshit Agarwal on 02/10/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel{
    let uid: String
    let displayName: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
    }
}

enum AuthProviderOption: String{
    case email = "password"
    case google = "google.com"
}

final class AuthenticationManager {
    
    static  let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
        
    }
    func getProviders() throws -> [AuthProviderOption]{
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData{
            if  let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
            }else{
                assertionFailure("Provider Option Not found: \(provider.providerID)")
            }

        }
        return providers
    }
    
    @discardableResult
    func createUser(email: String, password: String ) async throws -> AuthDataResultModel {
        let authDataResult = try await  Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String ) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: email)
    }

    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
}

extension AuthenticationManager {
    
    func signInWithGoogle(credential: AuthCredential) async throws  -> AuthDataResultModel{
      let authDataResult =  try await Auth.auth().signIn(with: credential)
        let authDataResultModel = AuthDataResultModel(user: authDataResult.user)
        let user = dbUser(auth: authDataResultModel)
        try await UserManager.shared.createNewUser(user: user)
//        try await UserManager.shared.createNewUser(auth: authDataResultModel)
        return authDataResultModel
    }
    
}
