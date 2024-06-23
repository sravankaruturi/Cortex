//
//  ItemModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import Foundation
import SwiftData

final class ItemModel : Codable, Identifiable {
    
    // We're using strings here because they're a little bit easier to work with when we try to integrate with 3rd party databases
    // @Attribute(.unique)
    var id: String
    
    var title: String 
    var isCompleted: Bool
    var hasReminder: Bool
    var dueDate: Date
    var sortOrder: Int
    
    var createdDate: Date
    
    public init(id: String = UUID().uuidString, title: String = "", isCompleted: Bool = false, hasReminder: Bool = false, dueDate: Date = Date(), createdDate: Date = .now) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.hasReminder = hasReminder
        self.dueDate = dueDate
        self.sortOrder = -1
        
        self.createdDate = createdDate
    }

    
    func toggleCompletion() -> ItemModel{
        return ItemModel(id: self.id, title: self.title, isCompleted: !self.isCompleted)
    }
    
}
