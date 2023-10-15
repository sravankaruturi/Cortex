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
    
    @Query() var items: [ItemModel]
    
    var body: some View {
        List{
            ForEach(items){ item in
                ListRowView(item: item)

            }
            .onDelete{ indexes in
                for index in indexes {
                    context.delete(items[index])
                }
            }
            .onMove{ _, _ in
                // listViewModel.moveItem(items: items, context: context)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Todo List 📝")
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                EditButton()
            }
            ToolbarItem(placement: .bottomBar){
                NavigationLink{
                    AddView()
                }
                label: {
                    ZStack{
                        
                        Circle()
                        
                        Image(systemName: "plus")
                            .frame(width: 50, height: 50)
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                        
                    }
                }
            }
        }
    }

}
