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
            dueDate: dueDate,
            createdDate: createdDate
        )
        
    }
    
}

final class ItemManager {
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func getItems() async throws  -> [ItemModel] {
        
        let itemSnapShot = try await Firestore.firestore().collection("users").document(userId).collection("data").getDocuments()
        
        var items: [ItemModel] = []
        
        // TODO: This is a testable function that can be extracted.
        for document in itemSnapShot.documents {
            try items.append(ItemModel(document: document))
        }
        
        return items
        
    }
    
    func addItem(item: ItemModel) async throws {
        let doc = Firestore.firestore().collection("users").document(userId).collection("data")
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
    
    func saveItem(item: ItemModel) async throws {
        let doc = Firestore.firestore().collection("users").document(userId).collection("data").document(item.id)
        try await doc.updateData(
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
    
}
