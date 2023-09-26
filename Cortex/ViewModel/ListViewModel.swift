//
//  ListViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/26/23.
//

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
    
    func addItem(title: String){
        let newItem = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
    }
}
