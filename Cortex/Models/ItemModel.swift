//
//  ItemModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import Foundation

// Immutable Structs.
// All are let variables.
// Only the methods can change the model.

struct ItemModel: Identifiable{
    
    // We're using strings here because they're a little bit easier to work with when we try to integrate with 3rd party databases
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func toggleCompletion() -> ItemModel{
        return ItemModel(id: self.id, title: self.title, isCompleted: !self.isCompleted)
    }
    
}
