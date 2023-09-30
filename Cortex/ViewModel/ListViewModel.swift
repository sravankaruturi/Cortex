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

class ListViewModel: ObservableObject{
    
    @Published var items: [ItemModel] = []
    
    init() {
        getItems()
    }
    
    // Add some dummy items for now.
    func getItems(){
        let newItems = [
            ItemModel(title: "This is the first title", isCompleted: false),
            ItemModel(title: "This is the second", isCompleted: true),
            ItemModel(title: "Third", isCompleted: false),
        ]
        items.append(contentsOf: newItems)
    }
    
    func moveItem(oldIndex: IndexSet, newIndex: Int){
        items.move(fromOffsets: oldIndex, toOffset: newIndex)
    }
    
    func deleteItem(index: IndexSet){
        items.remove(atOffsets: index)
    }
    
    func addItem(title: String, hasReminder: Bool, dueDate: Date){
        let newItem = ItemModel(title: title, isCompleted: false, hasReminder: hasReminder, dueDate: dueDate)
        items.append(newItem)
    }
    
    func updateItem(item: ItemModel){
        if let itemIndex = items.firstIndex(where: {$0.id == item.id }){
            items[itemIndex] = item.toggleCompletion()
        }else{
            print("Trying to get a non existent item: " + item.id + "-" + item.title)
        }
    }
}
