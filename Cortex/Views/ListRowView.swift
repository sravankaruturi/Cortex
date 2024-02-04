//
//  ListRowView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI
import SwiftData

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


#Preview {
    
//    var item1 = ItemModel(title: "This is the first thing", isCompleted: false)
//    var item2 = ItemModel(title: "This is the second", isCompleted: true)
//    var item3 = ItemModel(title: "Third", isCompleted: false)
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    do {
        let container = try! ModelContainer(for: ItemModel.self, configurations: config)
        
        let item = ItemModel(id: "", title: "Cheese", isCompleted: false, hasReminder: true, dueDate: Date(), createdDate: Date())
        
        return ListRowView(item: item)
            .modelContainer(container)
            .padding(.all)
    }
    catch{
        return Text(error.localizedDescription)
    }
    
}
