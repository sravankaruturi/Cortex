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
    
    let itemsKey: String = "items_list"
    
    @Published var items: [ItemModel] = [] {
        didSet{
            // gets called any time the array gets set/modified
            saveItems()
        }
    }
    
    init() {
        getItems()
    }
    
    // Add some dummy items for now.
    func getItems(){
        
        guard 
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let loadedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        self.items = loadedItems
        
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
    
    func saveItems(){
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
}
