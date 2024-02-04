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
    
    @Query(sort: \ItemModel.sortOrder) var items: [ItemModel]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(items){ item in
                    ListRowView(item: item)
                    
                }
                .onDelete{ indexes in
                    for index in indexes {
                        context.delete(items[index])
                    }
                }
                .onMove(perform: { indices, newOffset in
                    move(from: indices, to: newOffset)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Todo List 📝")
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
//                    ZStack{
//                        
//                        Circle()
//                        
//                        Image(systemName: "plus")
//                            .frame(width: 50, height: 50)
//                            .shadow(radius: 10)
//                            .foregroundColor(.white)
//                        
//                    }
                }
                }
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int){
        
        var revisedItems: [ ItemModel ] = items.map{ $0 }
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
