//
//  ListRowView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .yellow)
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
    }
}


struct ListRowView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(title: "This is the first thing", isCompleted: false)
    static var item2 = ItemModel(title: "This is the second", isCompleted: true)
    static var item3 = ItemModel(title: "Third", isCompleted: false)
    
    static var previews: some View{
        
        Group{
            ListRowView(item: item1)
            ListRowView(item: item2)
            ListRowView(item: item3)
        }.previewLayout(.sizeThatFits)
    }
    
}
