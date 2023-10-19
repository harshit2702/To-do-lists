//
//  ProfileView.swift
//  To do lists
//
//  Created by Harshit Agarwal on 16/10/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user: dbUser? = nil
    
    func loadCurrentUser()  async throws {
        let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(uid: authDataResult.uid)
    }
    func tooglePremiunStatus() {
        
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task{
            try await UserManager.shared.updateUserPremiumStatus(uid: user.uid,  isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func addUserPreferences(_ preferences: [String]) {
        guard let user else { return }
        Task{
            try await UserManager.shared.addUserPreferences(uid: user.uid, preferences: preferences)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func removeUserPreferences(_ preferences: [String]) {
        guard let user else { return }
        Task{
            try await UserManager.shared.removeUserPreferences(uid: user.uid, preferences: preferences)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func addList() {
        guard let user else { return}
        let list = [newLists2(name: "Item", isprivate: false, date: Date())]
        Task{
            try await UserManager.shared.addList(uid: user.uid, list: list)
            self.user = try await UserManager.shared.getUser(uid: user.uid)

        }
    }
    
    func addogList() {
        guard let user else { return }
        do {
            let data = try Data(contentsOf: savedPath)
            var newlists = try JSONDecoder().decode([newLists].self, from: data)
            if let unwrapped = user.ogLists {
                let list = unwrapped.filter { list in
                    !newlists.contains { $0 == list }
                }
                newlists.append(contentsOf: list)
            }
            Task{
                try await UserManager.shared.addogList(uid: user.uid, list: newlists)
                self.user = try await UserManager.shared.getUser(uid: user.uid)
                save(newlists)
            }
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOption = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(_ option: String) -> Bool {
        viewModel.user?.preferences?.contains(option) == true
    }
    
    var body: some View {
        
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            if let user = viewModel.user {
                Text("UserId: \(user.uid)")
                
                Text("Name: \(user.name ?? "N/A")")
                
                if let date = (user.dateCreated){
                    Text("Date Created: \(date)")

                }
                
                
                Button {
                    viewModel.tooglePremiunStatus()
                }label: {
                    Text("User is Premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack{
                        ForEach(preferenceOption, id: \.self) { option in
                            Button(option){
                                if preferenceIsSelected(option){
                                    viewModel.removeUserPreferences([option])
                                }else{
                                    viewModel.addUserPreferences([option])
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(option) ? .blue : .gray)
                        }
                    }
                    
                    Text("User Preferences: \((viewModel.user?.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Button{
                    viewModel.addogList()
                }label: {
                    Text("Lists: \(user.ogLists?.count ?? 0)")
                }
            }
            
            
        }
        .task{
            try? await  viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink{
                    settingView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
}
