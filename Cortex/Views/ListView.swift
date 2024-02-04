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
                //            .onMove{ from, to in
                //                print("On Move Entered")
                //                for (i, item) in items.enumerated(){
                //                    item.sortOrder = i
                //                    if ( item.isCompleted ){
                //                        item.sortOrder = Int.max
                //                    }
                //                }
                //            }
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

}

#Preview {
    ListView()
        .modelContainer(for: [ItemModel.self])
}
