//
//  AddView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    
    @State private var item: ItemModel = ItemModel()
    
    var body: some View {
        
        ScrollView{
            
            VStack{
                TextField("Type something here...", text: $item.title)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(20)
                
                Toggle(isOn: $item.hasReminder){
                    Text("Reminder")
                }
                
                if (item.hasReminder){
                    DatePicker("Due Date", selection: $item.dueDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
            }
            .padding(15)
            
        }
        .navigationTitle("Add an Item 🖋️")
        
    }
    
    func saveButtonPressed(){
        if isValidText(){
            withAnimation {
                context.insert(item)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func isValidText() -> Bool {
        if item.title.isEmpty {
            return false
        }
        return true
    }
}
