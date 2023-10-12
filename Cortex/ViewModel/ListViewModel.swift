//
//  ListViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/26/23.
//

/*
 CRUD
 
 Create
 Read
 Update
 Delete
 */

import Foundation
import SwiftData

class ListViewModel: ObservableObject{
    
    init() {
        
    }
        
    func addItem(title:String, hasReminder: Bool, dueDate: Date, context: ModelContext){
        let item = ItemModel(title: title, isCompleted: false, hasReminder: hasReminder, dueDate: dueDate)
        context.insert(item)
    }
    
//    func editItem(item: CDItem, title: String, isCompleted: Bool, hasReminder: Bool, dueDate: Date){
//        item.title = title
//        item.isCompleted = isCompleted
//        item.hasReminder = hasReminder
//        item.dueDate = dueDate
//        
//        save(context: context)
//    }
    
    func toggleItemCompleted(item: ItemModel, context: ModelContext){
        item.isCompleted = !item.isCompleted
        try? context.save()
    }

    
//    func moveItem(oldIndex: IndexSet, newIndex: Int){
//        items.move(fromOffsets: oldIndex, toOffset: newIndex)
//    }
//    
    func deleteItem(item: ItemModel, context: ModelContext){
        context.delete(item)
    }
    
}
