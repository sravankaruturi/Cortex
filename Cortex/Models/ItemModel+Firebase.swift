//
//  ItemModel+Firebase.swift
//  Cortex
//
//  Created by Sravan Karuturi on 6/23/24.
//

import FirebaseFirestore

extension ItemModel {
    
    public convenience init(document: QueryDocumentSnapshot) throws {
        
        let id = document.documentID
        let title = document.data()["title"] as? String ?? ""
        let isCompleted = document.data()["is_completed"] as? Bool ?? false
        let hasReminder = document.data()["has_reminder"] as? Bool ?? false
        let dueDate = document.data()["due_date"] as? Date ?? Date()
        let sortOrder = document.data()["sort_order"] as? Int ?? 0
        let createdDate = document.data()["created_date"] as? Date ?? Date()
        
        self.init(
            id: id,
            title: title,
            isCompleted: isCompleted,
            hasReminder: hasReminder,
            createdDate: createdDate
        )
        
    }
    
}
