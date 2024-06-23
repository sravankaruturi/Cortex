//
//  ListView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    @State private var completedExpanded: Bool = false
    @State private var incompleteExpanded: Bool = true
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        NavigationStack{
            List{
                Section("To Do", isExpanded: $incompleteExpanded) {
                    ForEach(cortexVM.dbUser!.items){ item in
                        ListRowView(item: item)
                    }
                    .onDelete{ indexes in
                        // TODO: Fix deletion
                    }
                    .onMove(perform: { indices, newOffset in
                        move(from: indices, to: newOffset)
                    })
                }
                
                Section("Completed", isExpanded: $completedExpanded){
                    ForEach(cortexVM.dbUser!.items){ item in
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
                    }
                }
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int){
        
        // TODO: Fix this 
//        var revisedItems: [ ItemModel ] = incompleteItems.map{ $0 }
//        revisedItems.move(fromOffsets: source, toOffset: destination)
//        
//        for reverseIndex in stride( from: revisedItems.count - 1, through: 0, by: -1 )
//        {
//            revisedItems[reverseIndex].sortOrder = reverseIndex
//        }
        
    }

}

#Preview {
    ListView()
}
