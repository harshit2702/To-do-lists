//
//  FireStore.swift
//  To do lists
//
//  Created by Harshit Agarwal on 16/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct newLists2:  Codable,Hashable{
    let name: String
    let isprivate: Bool
    var date: Date
}

struct dbUser: Codable{
    let uid: String
    let name: String?
    let dateCreated: Date?
    var isPremium: Bool?
    let preferences: [String]?
    let lists: [newLists2]?
    let ogLists: [newLists]?
    
    init(uid: String, name: String? = nil, dateCreated: Date? = nil, isPremium: Bool? = nil, preferences: [String]? = nil, lists: [newLists2]? = nil, ogLists: [newLists]?) {
        self.uid = uid
        self.name = name
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.lists = lists
        self.ogLists = ogLists
    }
    
    init(auth: AuthDataResultModel){
        self.uid = auth.uid
        self.name = auth.displayName
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.lists = nil
        self.ogLists = nil
    }
    
    enum CodingKeys: CodingKey{
        case uid
        case name
        case dateCreated
        case isPremium
        case preferences
        case lists
        case ogLists
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.lists = try container.decodeIfPresent([newLists2].self, forKey: .lists)
        self.ogLists = try container.decodeIfPresent([newLists].self, forKey: .ogLists)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uid, forKey: .uid)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.isPremium, forKey: .isPremium)
        try container.encode(self.preferences, forKey: .preferences)
        try container.encode(self.lists, forKey: .lists)
        try container.encode(self.ogLists, forKey: .ogLists)
    }
    
//    func tooglePremiunStatus() -> dbUser{
//        let currentValue = isPremium ?? false
//        return dbUser(
//            uid: uid,
//            name: name,
//            dateCreated: dateCreated,
//            isPremium: !currentValue
//        )
//    }
        
}

final class UserManager{
    
    static let shared = UserManager()
    private init() {
        
    }
    
    private let encoder: Firestore.Encoder = {
            let encoder = Firestore.Encoder()
    //        encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }()

        private let decoder: Firestore.Decoder = {
            let decoder = Firestore.Decoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(uid: String) -> DocumentReference {
        userCollection.document(uid)
    }
    
    func createNewUser(user :dbUser) async throws{
        try  userDocument(uid: user.uid).setData(from: user, merge: false)
    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws{
//        var userData: [String : Any] = [
//            "uid" : auth.uid,
//            "name" : auth.displayName,
//            "dateCreated" : Date(),
//        ]
//        try await userDocument(uid: auth.uid).setData(userData, merge: false)
//        
//    }
    func getUser(uid: String) async throws -> dbUser{
        try await userDocument(uid: uid).getDocument(as: dbUser.self)
    }
    
    
//    func getUser(uid: String) async throws -> dbUser {
//        let snapshot = try await userDocument(uid: uid).getDocument()
//        
//        guard let data = snapshot.data() else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let uid = data["uid"] as? String
//        let name = data["name"] as? String
//        if let googleTimestamp = data["dateCreated"] as? Timestamp{
//            let seconds = Double(googleTimestamp.seconds)
//            let date = Date(timeIntervalSince1970: seconds)
//            
//            return dbUser(uid: uid!, name: name, dateCreated: date)
//            
//        }
//        return dbUser(uid: uid!, name: name, dateCreated: nil)
//
//    }
    
    //Function to update user premium status
    func updateUserPremiumStatus(uid: String, isPremium: Bool) async throws {
        try await userDocument(uid: uid).updateData(["isPremium": isPremium])
    }
    
    func addUserPreferences(uid: String, preferences: [String]) async throws {
        try await userDocument(uid: uid).updateData(["preferences": FieldValue.arrayUnion(preferences)])
    }
    
    func removeUserPreferences(uid: String, preferences: [String]) async throws {
        try await userDocument(uid: uid).updateData(["preferences": FieldValue.arrayRemove(preferences)])
    }
    
    func addList(uid: String, list: [newLists2]) async throws {
        let encodedList = list.map { try? encoder.encode($0) }.compactMap { $0 }

        try await userDocument(uid: uid).updateData(["lists": FieldValue.arrayUnion(encodedList)])
    }
    
    func addogList(uid: String, list: [newLists]) async throws {
        let encodedList = list.map { try? encoder.encode($0) }.compactMap { $0 }

        try await userDocument(uid: uid).updateData(["ogLists": FieldValue.arrayUnion(encodedList)])
    }

    
}
