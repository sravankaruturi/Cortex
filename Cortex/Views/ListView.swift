//
//  ListView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    @Environment(\.modelContext) var context
    
    @Query(filter: #Predicate<ItemModel>{!$0.isCompleted}, sort: \ItemModel.sortOrder, animation: .easeInOut(duration: 0.5)) var incompleteItems: [ItemModel]
    
    @Query(filter: #Predicate<ItemModel>{$0.isCompleted}, sort: \ItemModel.sortOrder) var completeItems: [ItemModel]
    
    @State private var completedExpanded: Bool = false
    @State private var incompleteExpanded: Bool = true
    
    var body: some View {
        NavigationStack{
            List{
                Section("To Do", isExpanded: $incompleteExpanded) {
                    ForEach(incompleteItems){ item in
                        ListRowView(item: item)
                    }
                    .onDelete{ indexes in
                        for index in indexes {
                            context.delete(incompleteItems[index])
                        }
                    }
                    .onMove(perform: { indices, newOffset in
                        move(from: indices, to: newOffset)
                    })
                }
                
                Section("Completed", isExpanded: $completedExpanded){
                    ForEach(completeItems){ item in
                        ListRowView(item: item)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("All Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink{
                        AddView()
                    }
                label: {
                    Image(systemName: "plus")
                    //                        ZStack{
                    //
                    //                            Circle()
                    //
                    //                            Image(systemName: "plus")
                    //                                .frame(width: 50, height: 50)
                    //                                .shadow(radius: 10)
                    //                                .foregroundColor(.white)
                    //
                    //                        }
                    }
                }
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int){
        
        var revisedItems: [ ItemModel ] = incompleteItems.map{ $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for reverseIndex in stride( from: revisedItems.count - 1, through: 0, by: -1 )
        {
            revisedItems[reverseIndex].sortOrder = reverseIndex
        }
        
    }

}

#Preview {
    ListView()
        .modelContainer(for: [ItemModel.self])
}
