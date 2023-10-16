//
//  ListRowView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI

struct ListRowView: View {
    
    @Bindable var item: ItemModel
    
    @Environment(\.modelContext) var context
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .yellow)
                    .onTapGesture {
                        withAnimation(.linear){
                            NotificationManager.instance.removeNotificationForItem(item)
                            item.isCompleted.toggle()
                        }
                    }
                Text(item.title)
                Spacer()
            }
            .font(.title2)
            .padding(.vertical, 8)
            
            if item.hasReminder{
                HStack{
                    Text(item.dueDate.formatted())
                    Spacer()
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.vertical, 4)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                withAnimation {
                    context.delete(item)
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .symbolVariant(.fill)
            }
            
            Button {
                showEditView = true
            } label: {
                Label("Edit", systemImage: "pencil")
                    .symbolVariant(.fill)
            }

        }
        .sheet(isPresented: $showEditView, content: {
            EditListRowView(todoItem: item)
                .presentationDetents([.medium])
        })
        
    }
}


//struct ListRowView_Previews: PreviewProvider {
//    
//    static var item1 = ItemModel(title: "This is the first thing", isCompleted: false)
//    static var item2 = ItemModel(title: "This is the second", isCompleted: true)
//    static var item3 = ItemModel(title: "Third", isCompleted: false)
//    
//    static var previews: some View{
//        
//        ListRowView(item: item1)
//        
//    }
//    
//}
