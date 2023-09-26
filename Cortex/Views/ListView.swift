//
//  ListView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        List{
            ForEach(listViewModel.items){ item in
                ListRowView(item: item)
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
        .listStyle(.plain)
        .navigationTitle("Todo List 📝")
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                EditButton()
            }
            ToolbarItem(placement: .bottomBar){
                NavigationLink("Add", destination: AddView())
            }
        }
    }

}

#Preview {
    NavigationView{
        ListView()
    }
    .environmentObject(ListViewModel())
}
