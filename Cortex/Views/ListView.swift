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
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Query() var items: [ItemModel]
    
    var body: some View {
        List{
            ForEach(items){ item in
                ListRowView(item: item)

            }
            .onDelete{ indexes in
                for index in indexes {
                    listViewModel.deleteItem(item: items[index], context: context)
                }
            }
//            .onMove(perform: listViewModel.moveItem)
        }
        .listStyle(.plain)
        .navigationTitle("Todo List 📝")
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                EditButton()
            }
            ToolbarItem(placement: .bottomBar){
                NavigationLink(destination: AddView()){
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

//#Preview {
//    NavigationView{
//        ListView()
//    }
//    .environmentObject(ListViewModel())
//}
