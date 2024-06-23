//
//  ListRowView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI
import SwiftData

struct ListRowView: View {
    
    @State var item: ItemModel
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .yellow)
                    .onTapGesture {
                        withAnimation(.bouncy){
                            NotificationManager.instance.removeNotificationForItem(item)
                            item.isCompleted.toggle()
                            Task{
                                await cortexVM.saveItem(item)
                            }
                        }
                    }
                Text(item.title)
                Spacer()
                Image(systemName: "info.circle")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(cortexVM.tintColor)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            showEditView = true
                        }
                    }
            }
            .font(.title3)
            
            if item.hasReminder{
                HStack{
                    Text(item.dueDate.formatted())
                    Spacer()
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 2)
        .swipeActions {
            Button(role: .destructive) {
                withAnimation {
                    // TODO: Do Something here.
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
            EditListRowView(todoItem: $item)
                .presentationDetents([.medium])
        })
        
    }
}
