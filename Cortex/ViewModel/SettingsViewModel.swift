//
//  SettingsViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/29/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
final class SettingsViewModel : ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    @Published var dbUser: DBAccountInfo? = nil
    
    func loadCurrentUser() async throws {
        
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
        self.dbUser = try await UserManager.shared.getUser(userId: self.user!.uid)
        
    }
    
    func setColor(newColor: Color) async throws {
        dbUser?.accentColor = newColor
        try await UserManager.shared.updateUser(accountInfo: dbUser!)
    }
    
}

struct DBAccountInfo : Codable {
    
    let userId: String
    let email: String?
    let dateCreated: Date?
    var accentColor: Color
    
    enum CodingKeys : String, CodingKey {
        
        case userId = "user_id"
        case email = "email"
        case dateCreated = "date_created"
        case accentColor = "accent_color"
        
    }
    
    init(userId: String, email: String? , dateCreated: Date?, accentColor: Color ){
        self.userId = userId
        self.email = email
        self.dateCreated = dateCreated
        self.accentColor = accentColor
    }
    
    init(from decoder: Decoder) throws {
        let values  =   try decoder.container(keyedBy: CodingKeys.self)
        userId      =   try values.decode(String.self, forKey: .userId)
        email       =   try values.decodeIfPresent(String.self, forKey: .email)
        dateCreated =   try values.decodeIfPresent(Date.self, forKey: .dateCreated)
        
        let colorComponents =   try values.decodeIfPresent([Float].self, forKey: .accentColor) ?? nil
        var tintColor = Color.brandPrimary
        if ( colorComponents != nil ){
            tintColor = Color(uiColor: UIColor(
                red: CGFloat(colorComponents![0]),
                green: CGFloat(colorComponents![1]),
                blue: CGFloat(colorComponents![2]),
                alpha: 1.0
            ))
        }
        self.accentColor = tintColor
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        
        // Get the color components to encode color. Use NSColor for MACOs
        let colorComponents = self.accentColor.getRGBValues()
        try container.encode(
            colorComponents,
            forKey: .accentColor)
        
        
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        let userData: [String: Any] = [
            "user_id" : auth.uid,
            "date_created": Timestamp(),
            "email" : auth.email ?? "",
            "accent_color": [Color.brandPrimaryComponents]
        ]
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        
    }
    
    func updateUser(accountInfo: DBAccountInfo) async throws {
        let doc = Firestore.firestore().collection("users").document(accountInfo.userId)
        try await doc.updateData(
            [
                "accent_color": accountInfo.accentColor.getRGBValues()
            ]
        )
    }
    
    func getUser(userId: String) async throws -> DBAccountInfo {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse, userInfo: ["Info" : "Unable to parse the data"])
        }
        
        let email = data["email"] as? String
        let timeStamp = data["date_created"] as? Timestamp
        let dateCreated = ( timeStamp != nil ) ? ( timeStamp?.dateValue() ) : nil
        let tintColorComponents = data["accent_color"] as? [Float]
        var tintColor: Color = Color.brandPrimary
        
        if ( tintColorComponents != nil ){
            
            tintColor = Color(uiColor: UIColor(
                red: CGFloat(tintColorComponents![0]),
                green: CGFloat(tintColorComponents![1]),
                blue: CGFloat(tintColorComponents![2]),
                alpha: 1.0
            ))
            
        }
        
        return DBAccountInfo(userId: userId, email: email, dateCreated: dateCreated, accentColor: tintColor)
        
    }
    
}
