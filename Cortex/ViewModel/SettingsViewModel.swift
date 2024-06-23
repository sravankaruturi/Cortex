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
            "accent_color": [Color.brandPrimaryComponents]
        ]
        
        do {
            try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        }catch {
            print(error)
        }
        
    }
    
    func saveItem(item: ItemModel, accountInfo: DBAccountInfo) async throws {
        let doc = Firestore.firestore().collection("users").document(accountInfo.userId).collection("data")
        try await doc.addDocument(data:
        [
            "title"         : item.title,
            "is_completed"  : item.isCompleted,
            "has_reminder"  : item.hasReminder,
            "due_date"      : item.dueDate,
            "create_date"   : item.createdDate,
            "sort_order"    : item.sortOrder
        ]
        )
    }
    
    func updateUser(accountInfo: DBAccountInfo) async throws {
        
        let doc = Firestore.firestore().collection("users").document(accountInfo.userId)
        try await doc.updateData(
            [
                "accent_color": accountInfo.accentColor.getRGBValues(),
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
        
        let itemSnapShot = try await Firestore.firestore().collection("users").document(userId).collection("data").getDocuments()
        
        var items: [ItemModel] = []
        
        // TODO: This is a testable function that can be extracted.
        for document in itemSnapShot.documents {
            try items.append(ItemModel(document: document))
        }
        
        return DBAccountInfo(userId: userId, email: email, dateCreated: dateCreated, accentColor: tintColor, items: items)
        
    }
    
}
