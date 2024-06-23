//
//  ListModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 2/4/24.
//

import Foundation
import SwiftData

@Model
final class ListModel {
    
    @Attribute(.unique)
    var id: String
    
    var title: String
    var expanded: Bool
    var sortOrder: Int
    
    
    public init(id: String = UUID().uuidString, title: String = "", expanded: Bool = true, sortOrder: Int = -1) {
        self.id = id
        self.title = title
        self.expanded = expanded
        self.sortOrder = sortOrder
    }
    
    func toggleExpansion() -> ListModel {
        return ListModel(id: self.id, title: self.title, expanded: !self.expanded, sortOrder: self.sortOrder)
    }
}
