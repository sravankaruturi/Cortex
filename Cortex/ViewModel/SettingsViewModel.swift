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

final class UserManager {
    
    func loginOrCreateNewUser(auth: AuthDataResultModel) async throws {
        
        let userData: [String: Any] = [
            "user_id" : auth.uid,
            "date_created": Timestamp(),
            "email" : auth.email ?? "",
            "accent_color_x": Color.brandPrimaryComponents[0],
            "accent_color_y": Color.brandPrimaryComponents[1],
            "accent_color_z": Color.brandPrimaryComponents[2],
        ]
        
        // TODO: We are overwriting the data with defaults here.
        // Try to separate the Login and Create New User functions.
        
        do {
            try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        }catch {
            print(error)
        }
        
    }
    
    func updateUser(accountInfo: DBAccountInfo) async throws {
        
        let doc = Firestore.firestore().collection("users").document(accountInfo.userId)
        let rgb = accountInfo.accentColor.getRGBValues()
        try await doc.updateData(
            [
                "accent_color_x": rgb[0],
                "accent_color_y": rgb[1],
                "accent_color_z": rgb[2]
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
        let tint_x = data["accent_color_x"] as? Float
        let tint_y = data["accent_color_y"] as? Float
        let tint_z = data["accent_color_z"] as? Float
        var tintColor: Color = Color.brandPrimary
        
        if ( tint_x != nil ){
            
            tintColor = Color(uiColor: UIColor(
                red: CGFloat(tint_x!),
                green: CGFloat(tint_y!),
                blue: CGFloat(tint_z!),
                alpha: 1.0
            ))
            
        }
        

        
        return DBAccountInfo(userId: userId, email: email, dateCreated: dateCreated, accentColor: tintColor)
        
    }
    
}
