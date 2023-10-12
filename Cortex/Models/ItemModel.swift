//
//  ItemModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import Foundation
import SwiftData

// Immutable Structs.
// All are let variables.
// Only the methods can change the model.

@Model
class ItemModel: Identifiable {
    
    // We're using strings here because they're a little bit easier to work with when we try to integrate with 3rd party databases
    @Attribute(.unique)
    var id: String
    
    var title: String
    var isCompleted: Bool
    var hasReminder: Bool
    var dueDate: Date
    
    public init(id: String = UUID().uuidString, title: String, isCompleted: Bool, hasReminder: Bool = false, dueDate: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.hasReminder = hasReminder
        self.dueDate = dueDate
    }
    
    func toggleCompletion() -> ItemModel{
        return ItemModel(id: self.id, title: self.title, isCompleted: !self.isCompleted)
    }
    
}
